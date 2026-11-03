package com.ayjs.mxzg.common.config;

import com.ayjs.mxzg.common.config.system.ISystemBean;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.util.SymbolConstants;
import com.google.common.base.Throwables;
import lombok.extern.slf4j.Slf4j;

import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.Arrays;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@Slf4j
public abstract class SystemConfig<T extends ISystemBean<?>> extends BaseConfig<T> {

    @Override
    protected void loadOther() {
        super.loadOther();
        checkSystemMethod();
    }

    private void checkSystemMethod() {
        Class<?> clazz = this.getClass();
        Map<String, Field> fieldMap = Arrays.stream(clazz.getDeclaredFields())
                .filter(field -> !Modifier.isTransient(field.getModifiers()))
                .collect(Collectors.toMap(Field::getName, Function.identity()));
        for (T config : this.getConfigList()) {
            String fieldName = config.getKey().replaceAll(SymbolConstants.UNDERSCORE, SymbolConstants.EMPTY);
            fieldName = fieldName.substring(0, 1).toLowerCase() + fieldName.substring(1);

            // 去除已有的
            fieldMap.remove(fieldName);
            try {
                Field field = clazz.getDeclaredField(fieldName);
                field.setAccessible(true);
                field.set(this, ConvertUtils.convertTo(config.getValue(), field.getGenericType()));
                field.setAccessible(false);
            } catch (NoSuchFieldException e) {
                log.warn("!!!!!!!!!!!!!!!!!!!!!!!!!! {} missing field {}", clazz.getSimpleName(), fieldName);
            } catch (Exception e) {
                Throwables.throwIfUnchecked(e);
                throw new RuntimeException(e);
            }
        }
        if (!fieldMap.isEmpty()) {
            // 打印多余字段
            fieldMap.forEach((k, v) -> log.warn("配置文件 {} 缺少field:{} 配置值", getFilename(), k));
        }
    }
}
