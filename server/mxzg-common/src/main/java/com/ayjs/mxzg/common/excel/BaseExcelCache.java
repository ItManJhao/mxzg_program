/**
 *
 */
package com.ayjs.mxzg.common.excel;

import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.lang.reflect.Field;
import java.lang.reflect.ParameterizedType;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.Function;

/**
 * @author YY
 *
 */
public abstract class BaseExcelCache<T extends BaseExcelModel> {

    protected static Logger logger = LoggerFactory.getLogger(BaseExcelCache.class);
    
    private static final int FIX_NAME_LENGTH = 40;
    
    private static final int FIX_COUNT_LENGTH = 5;

    @SuppressWarnings("unchecked")
    public BaseExcelCache() {
        ParameterizedType type = (ParameterizedType) this.getClass().getGenericSuperclass();
        clazz = (Class<T>) type.getActualTypeArguments()[0];

        ExcelLoader.register(this);
    }

    private Class<T> clazz;

    /**
     * excel文件的名字，不带后缀
     *
     * @return
     */
    public abstract String getFileName();

    private List<T> dataList;

    private Map<Integer, T> dataMap;
    
    /**
     * 加载数据
     */
    public void loadData(List<Map<String, String>> excelDatas) {
        List<T> tempDataList = new ArrayList<>();
        Map<Integer, T> tempDataMap = new HashMap<>();

        boolean flag = true;
        for (int i = 0; i < excelDatas.size(); i++) {
            Map<String, String> rowData = excelDatas.get(i);
            T t = formObject(i, rowData);
            //处理单个对象的个性加载
            formSpecial(t);

            if (Objects.isNull(t)) {
                flag = false;
                logger.error("加载[{}]配置为空 行数[{}] {}", getFileName(), i, GsonUtils.toJson(rowData));
            }

            if (tempDataMap.containsKey(t.getExcelId())) {
                flag = false;
                logger.error("加载[{}}]时出现重复的ID[{}] {}", getFileName(), t.getExcelId(), GsonUtils.toJson(rowData));
            } else {
                tempDataMap.put(t.getExcelId(), t);
                tempDataList.add(t);
            }
        }
        this.dataList = tempDataList;
        dataList.sort(Comparator.comparingInt(T::getExcelId));
        this.dataMap = tempDataMap;
        //加载自定义的结构
        loadAfterReady();
        logger.info("加载[{}]完成，数据数量[{}]", fixLength(getFileName(), FIX_NAME_LENGTH), fixLength(this.dataList.size() + "", FIX_COUNT_LENGTH));

        if (!flag) {
            throw new RuntimeException("加载 [" + getFileName() + "] 时出现错误");
        }
        ConfigAsserts.notNull(dataList, () -> String.format("无法加载到配置文件：{%s}的数据", getFileName()));
    }

    private static String fixLength(String str, int length) {
    	int fixLength = length - str.length();
    	if(fixLength < 0) {
    		fixLength = 0;
    	}
    	StringBuilder builder = new StringBuilder();
    	builder.append(str);
    	for(int i = 0; i < fixLength; i++) {
    		builder.append(" ");
    	}
    	return builder.toString();
    }

    /**
     * 根据id获取数据，如果数据不能为null则使用getOrThrow
     *
     * @param id
     * @return 数据不存在则返回null
     */
    public final T getById(int id) {
        ConfigAsserts.notNull(dataMap, () -> String.format("配置数据不存在{%s}{%s}", getFileName(), id));
        return dataMap.get(id);
    }

    public final T getOrThrow(int id) {
        ConfigAsserts.notNull(dataMap, () -> String.format("配置数据不存在{%s}{%s}", getFileName(), id));
        T data = dataMap.get(id);
        ConfigAsserts.notNull(data, () -> String.format("配置数据不存在{%s}{%s}", getFileName(), id));
        return data;
    }

    public final List<T> getAll() {
        return dataList;
    }

    /**
     * 构建一些本类型特有的数据结构
     *
     * @param t
     */
    protected void formSpecial(T t) {
    }

    /**
     * 在本类型数据加载完之后用于加载自定义的数据索引
     */
    protected void loadAfterReady() {
    }

    /**
     * 在所有类别的数据加载完之后用于加载自定义的数据索引
     */
    public void loadAfterAllReady() {
    }

    public Class<T> getClazz() {
        return clazz;
    }

    /**
     * 创建对象，并进行自动赋值
     *
     * @param rowNum  行号
     * @param rowData
     * @return
     */
    private final T formObject(int rowNum, Map<String, String> rowData) {
        String curFieldName = null;
        String curValue = null;
        try {
            T t = clazz.newInstance();
            Field[] fields = clazz.getDeclaredFields();
            for (Field field : fields) {
                String value = rowData.get(field.getName());
                curFieldName = field.getName();
                curValue = value;
                if (StringUtils.isBlank(value)) {
                    continue;
                }
                field.setAccessible(true);
                Object obj = ConvertUtils.convertTo(value, field.getGenericType());
                field.set(t, obj);
                field.setAccessible(false);

            }
            return t;
        } catch (Exception e) {
            logger.error("加载文件[{}]第[{}]行 field:[{}],value:[{}]时出错，错误信息[{}]",
                    this.getFileName(), (rowNum + 1), curFieldName, curValue, e.getMessage());
            e.printStackTrace();
        }
        return null;
    }


    /**
     * 创建双层Map
     *
     * @param keyOne
     * @param keyTwo
     * @return
     */
    protected final <K1, K2> Map<K1, Map<K2, T>> fillTwoLayerMap(Function<T, K1> keyOne, Function<T, K2> keyTwo) {
        Map<K1, Map<K2, T>> map = new HashMap<>();
        for (T t : this.getAll()) {
            K1 firstValue = keyOne.apply(t);
            K2 secondValue = keyTwo.apply(t);

            Map<K2, T> subMap = map.get(firstValue);
            if (subMap == null) {
                subMap = new HashMap<>();
                map.put(firstValue, subMap);
            }
            subMap.put(secondValue, t);
        }
        return map;
    }

    protected final <K> Map<K, T> fillOneLayerMap(Function<T, K> keyField) {
        Map<K, T> map = new HashMap<>();
        for (T t : this.getAll()) {
            map.put(keyField.apply(t), t);
        }
        return map;
    }

    protected final <K> Map<K, List<T>> fillListMap(Function<T, K> keyField) {
        Map<K, List<T>> map = new HashMap<>();
        for (T t : this.getAll()) {
            K keyValue = keyField.apply(t);
            List<T> list = map.get(keyValue);
            if (list == null) {
                list = new ArrayList<>();
                map.put(keyValue, list);
            }
            list.add(t);
        }
        return map;
    }

    public boolean check(T t) {
        return true;
    }

    public boolean check() {
        boolean checked = true;
        if (Objects.isNull(getAll())){
            logger.warn("excel is null :{}",getFileName());
            return false;
        }
        for (T config : getAll()) {
            try {
                boolean result = check(config);
                if (!result) {
                    checked = false;
                    logger.warn("check false:{}", config);
                }
            } catch (Exception e) {
                checked = false;
                e.printStackTrace();
            }
        }
        return checked;
    }
}
