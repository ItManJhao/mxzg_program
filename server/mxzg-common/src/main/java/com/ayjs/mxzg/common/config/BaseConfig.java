package com.ayjs.mxzg.common.config;

import com.ayjs.mxzg.common.config.reader.ReadType;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.util.SortUtil;
import com.google.common.base.Preconditions;
import com.google.common.base.Throwables;
import com.google.common.collect.ImmutableList;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.objenesis.Objenesis;
import org.objenesis.ObjenesisStd;

import java.lang.reflect.Field;
import java.lang.reflect.ParameterizedType;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@Slf4j
public abstract class BaseConfig<T> implements IConfig<T> {

    private static final Objenesis objenesis = new ObjenesisStd(true);

    private volatile ImmutableList<T> configList;
    private volatile ImmutableList<T> sortConfigList;

    @SuppressWarnings({"rawtypes", "unchecked"})
    protected final void loadMap(String[] indexes, Map map) {
        if (indexes == null || indexes.length <= 0) {
            return;
        }
        map.clear();
        try {
            for (T t : configList) {

                Map lastMap = map;

                for (int i = 0; i < indexes.length; i++) {
                    String index = indexes[i];

                    Field field = t.getClass().getDeclaredField(index);

                    field.setAccessible(true);

                    Object keyValue = field.get(t);
                    //最后一层
                    if (i + 1 >= indexes.length) {
                        lastMap.put(keyValue, t);
                    } else {
                        //逐层组装
                        Object mapValue = lastMap.get(keyValue);
                        if (mapValue == null) {
                            mapValue = new HashMap();
                        }
                        lastMap.put(keyValue, mapValue);
                        lastMap = (Map) mapValue;
                    }

                    field.setAccessible(false);
                }
            }
        } catch (Exception e) {
            Throwables.throwIfUnchecked(e);
            throw new RuntimeException(e);
        }
    }

    private void loadList(Class<T> clazz, String[] configHead, List<String[]> configDataList, String[] readType) {
        Map<String, Field> fieldMap = Arrays.stream(clazz.getDeclaredFields())
                .collect(Collectors.toMap(Field::getName, Function.identity()));

        List<T> configList = new ArrayList<>();
        for (int i = 0; i < configDataList.size(); i++) {
            String[] configData = configDataList.get(i);
            if (configData == null) {
                continue;
            }
            if (configData.length < configHead.length) {
                log.warn(clazz.getSimpleName() + " has warning on row " + (i + 2));
            }
            if (invalid(configData)) {
                continue;
            }
            try {
                configList.add(configToObject(clazz, fieldMap, configHead, configData, readType));
            } catch (Exception e) {
                throw new RuntimeException(clazz.getSimpleName() + " Row " + i + " " + e.getMessage(), e);
            }
        }
        this.configList = ImmutableList.copyOf(configList);
    }

    private boolean invalid(String[] configData) {
        return Arrays.stream(configData).allMatch(StringUtils::isBlank);
    }

    private void loadSortList() {
        if (this.getSorts() != null && this.getSorts().length > 0) {
            List<T> sortConfigList = new ArrayList<>(configList);
            SortUtil.sort(sortConfigList, this.getSorts());
            this.sortConfigList = ImmutableList.copyOf(sortConfigList);
        }
    }

    /**
     * 获取配置表所有数据的列表
     * <p>
     * PS：不保证顺序
     */
    public List<T> getConfigList() {
        return configList;
    }

    /**
     * 获取配置表的有序列表
     * <p>
     * PS：仅对只有一层的配置表有业务含义，两层或以上的配置表结构需要自定义存取的缓存
     */
    public List<T> getSortConfigList() {
        return sortConfigList;
    }

    private T configToObject(Class<T> clazz, Map<String, Field> fieldMap, String[] configHead, String[] configData,
                             String[] readType) throws Exception {
        T obj = objenesis.newInstance(clazz);
        for (int i = 0; i < configHead.length; i++) {
            Preconditions.checkNotNull(readType[i], "未设置读取类型设置");

            // 过滤后端不需要的数据
            int readTypeValue = ConvertUtils.toInt(readType[i]);
            ReadType type = ReadType.of(readTypeValue);
            Preconditions.checkNotNull(type, "读取类型{%s}错误", readTypeValue);
            if (type == ReadType.CLIENT_READ || type == ReadType.ENGINEER_READ) {
                continue;
            }

            // 表体的检测
            if (i >= configData.length) {
                break;
            }

            String fieldName = configHead[i];

            // 将首字母变成小写
            fieldName = fieldName.substring(0, 1).toLowerCase() + fieldName.substring(1);

            byte[] nameByte = fieldName.getBytes(StandardCharsets.UTF_8);
            // csv文件可以使用文本工具编辑，有时候会被保存为UTF-8 BOM的格式，这个格式在程序中无法解释
            if (nameByte.length != fieldName.length()) {
                throw new RuntimeException(clazz.getSimpleName() + " config form not right, can't UTF-8 BOM");
            }

            Field field = fieldMap.get(fieldName);
            if (field == null) {
                continue;
            }

            Object value = ConvertUtils.convertTo(configData[i], field.getGenericType());
            if (value == null) {
                continue;
            }

            field.setAccessible(true);
            field.set(obj, value);
            field.setAccessible(false);
        }
        return obj;
    }

    @Override
    public void loadCache(String[] configHead, List<String[]> configDataList, String[] readType) {
        loadList(getConfigClass(), configHead, configDataList, readType);
        loadSortList();
        loadOther();
        log.info("{} 加载完毕, size: {}", this.getFilename(), configList.size());
    }

    @SuppressWarnings("unchecked")
    @Override
    public Class<T> getConfigClass() {
        return (Class<T>) ((ParameterizedType) getClass().getGenericSuperclass()).getActualTypeArguments()[0];
    }

    /**
     * 加载完数据后的扩展处理
     */
    protected void loadOther() {
        // default do nothing
    }
}
