package com.ayjs.mxzg.common.persistence;

import com.ayjs.mxzg.common.persistence.annotation.Column;

import java.lang.reflect.Field;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Date;

/**
 * 类型
 */
public enum TypeEnum {
    TINYINT,
    SMALLINT,
    INT,
    BIGINT,
    DOUBLE,
    CHAR,
    VARCHAR,
    LONGTEXT,
    TEXT,
    DATETIME,
    DATE,
    TIME,
    OBJ,// 自定义对象数据
    BLOB,
    ;

    public static TypeEnum parseFromTypeString(String type) {
        type = type.toUpperCase();
        for (TypeEnum tp : values()) {
            if (type.startsWith(tp.name())) {
                return tp;
            }
        }
        return null;
    }

    public static TypeEnum getTypeOfField(Field field) {
        Class<?> type = field.getType();
        if (type == Long.TYPE || type == Long.class)
            return BIGINT;
        if (type == Integer.TYPE || type == Integer.class)
            return INT;
        if (type == Short.TYPE || type == Short.class)
            return SMALLINT;
        if (type == Byte.TYPE || type == Byte.class)
            return TINYINT;
        if (type == Boolean.TYPE || type == Boolean.class)
            return TINYINT;
        if (type == Double.TYPE || type == Double.class || type == Float.TYPE || type == Float.class)
            return DOUBLE;
        if (type == String.class) {
            Column column = field.getAnnotation(Column.class);
            if (column.length() >= 256) {
                return TEXT;
            } else {
                if (column.immutable()) {
                    return CHAR;
                } else {
                    return VARCHAR;
                }
            }
        }
        if (type == Character.class) {
            return CHAR;
        }
        if (type == LocalDateTime.class) {
            return DATETIME;
        }
        if (type == Date.class || type == LocalDate.class) {
            return DATE;
        }
        if (type == LocalTime.class) {
            return TIME;
        }

        if (type.isEnum()) {
            return INT;
        } else if (type.isArray()) {
            if (type.getComponentType() == byte.class) {
                return BLOB;
            } else {
                return OBJ;
            }
        } else {
            return OBJ;
        }
    }

    public static boolean hasDefaultValue(TypeEnum type) {
        switch (type) {
            case BLOB:
            case OBJ:
            case TEXT:
            case LONGTEXT:
                return false;
        }
        return true;
    }
}
