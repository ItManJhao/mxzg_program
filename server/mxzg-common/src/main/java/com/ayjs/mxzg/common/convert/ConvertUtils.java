package com.ayjs.mxzg.common.convert;

import com.ayjs.mxzg.common.convert.annotation.EnumMode;
import com.ayjs.mxzg.common.convert.annotation.ValueMode;
import com.ayjs.mxzg.common.util.EnumUtils;
import com.ayjs.mxzg.common.util.TypeUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.google.common.base.Preconditions;
import com.google.common.reflect.TypeToken;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.reflect.TypeUtils;

import java.lang.reflect.Array;
import java.lang.reflect.Type;
import java.lang.reflect.TypeVariable;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

/**
 * 类型转换工具
 */
public class ConvertUtils {

    private static final ConcurrentMap<Type, Converter<?>> converters = new ConcurrentHashMap<>();

    public static void registerConverter(Converter<?> converter) {
        Type classType = TypeUtil.resolveTypeArguments(converter.getClass(), Converter.class)[0];
        Converter<?> old = converters.putIfAbsent(classType, converter);
        Preconditions.checkArgument(old == null, "重复的转换器注册{}", classType.getTypeName());
    }

    public static byte toByte(Object input) {
        if (input instanceof Number) {
            return ((Number) input).byteValue();
        } else if (input instanceof String) {
            return Double.valueOf((String) input).byteValue();
        } else {
            throw new RuntimeException(String.format("值 [%s] 不能转换为 byte 型", input));
        }
    }

    public static byte toByte(Object input, byte defaultValue) {
        if (input == null) {
            return defaultValue;
        }
        return toByte(input);
    }

    public static short toShort(Object input) {
        if (input instanceof Number) {
            return ((Number) input).shortValue();
        } else if (input instanceof String) {
            return Double.valueOf((String) input).shortValue();
        } else {
            throw new RuntimeException(String.format("值 [%s] 不能转换为 short 型", input));
        }
    }

    public static short toShort(Object input, short defaultValue) {
        if (input == null) {
            return defaultValue;
        }
        return toShort(input);
    }

    public static int toInt(Object input) {
        if (input instanceof Number) {
            return ((Number) input).intValue();
        } else if (input instanceof String) {
            return Double.valueOf((String) input).intValue();
        } else if (input instanceof Enum) {
            return ((Enum<?>) input).ordinal();
        } else {
            throw new RuntimeException(String.format("值 [%s] 不能转换为 int 型", input));
        }
    }

    public static int toInt(Object input, int defaultValue) {
        if (input == null) {
            return defaultValue;
        }
        return toInt(input);
    }

    public static long toLong(Object input) {
        if (input instanceof Number) {
            return ((Number) input).longValue();
        } else if (input instanceof String) {
            return Double.valueOf((String) input).longValue();
        } else {
            throw new RuntimeException(String.format("值 [%s] 不能转换为 long 型", input));
        }
    }

    public static long toLong(Object input, long defaultValue) {
        if (input == null) {
            return defaultValue;
        }
        return toLong(input);
    }

    public static float toFloat(Object input) {
        if (input instanceof Number) {
            return ((Number) input).floatValue();
        } else if (input instanceof String) {
            return Double.valueOf((String) input).floatValue();
        } else {
            throw new RuntimeException(String.format("值 [%s] 不能转换为 float 型", input));
        }
    }

    public static float toFloat(Object input, float defaultValue) {
        if (input == null) {
            return defaultValue;
        }
        return toFloat(input);
    }

    public static double toDouble(Object input) {
        if (input instanceof Number) {
            return ((Number) input).doubleValue();
        } else if (input instanceof String) {
            return Double.valueOf((String) input);
        } else {
            throw new RuntimeException(String.format("值 [%s] 不能转换为 double 型", input));
        }
    }

    public static double toDouble(Object input, double defaultValue) {
        if (input == null) {
            return defaultValue;
        }
        return toDouble(input);
    }

    public static boolean toBoolean(Object input) {
        if (input instanceof Boolean) {
            return (Boolean) input;
        } else if (input instanceof Number) {
            return ((Number) input).intValue() == 1;
        } else if (input instanceof String) {
            String stringValue = (String) input;
            return "true".equalsIgnoreCase(stringValue) || toInt(input) == 1;
        } else {
            throw new RuntimeException(String.format("值 [%s] 不能转换为 boolean 型", input));
        }
    }

    @SuppressWarnings({"unchecked", "rawtypes"})
    public static <T> T toEnum(Object input, Class<T> enumClass) {
        if (input == null) {
            return null;
        }
        if (input.getClass() == enumClass) {
            return (T) input;
        }

        EnumMode enumMode = enumClass.getAnnotation(EnumMode.class);
        ValueMode valueMode = enumMode == null ? ValueMode.ORDINAL : enumMode.value();
        if (valueMode == ValueMode.ORDINAL) {
            return (T) EnumUtils.getEnum((Class) enumClass, ConvertUtils.toInt(input));
        } else if (valueMode == ValueMode.NAME) {
            return (T) EnumUtils.valueOf((Class) enumClass, (String) input);
        } else {
            return (T) EnumUtils.getEnumByValue((Class) enumClass, ConvertUtils.toInt(input));
        }
    }

    public static <T> T toEnum(Object input, Class<T> enumClass, T valueIfNull) {
        if (input == null) {
            return valueIfNull;
        }
        return toEnum(input, enumClass);
    }

    public static Object getEnumValue(Object input) {
        if (input == null) {
            return null;
        }

        EnumMode enumMode = input.getClass().getAnnotation(EnumMode.class);
        if (enumMode != null) {
            if (enumMode.value() == ValueMode.NAME) {
                return ((Enum<?>) input).name();
            } else if (enumMode.value() == ValueMode.VALUE) {
                return EnumUtils.getEnumValue(input);
            }
        }
        return ((Enum<?>) input).ordinal();
    }

    public static String toString(Object input) {
        if (input == null) {
            return null;
        }
        if (input instanceof String) {
            return (String) input;
        } else if (input instanceof byte[]) {
            try {
                return new String((byte[]) input, Charset.defaultCharset());
            } catch (Exception e) {
                throw new RuntimeException(String.format("字符集编码 [%s] 构建 String !", Charset.defaultCharset()));
            }
        }
        return String.valueOf(input);
    }

    /**
     * 类型转换
     *
     * @param value
     * @return
     */
    @SuppressWarnings("unchecked")
    public static <T, V> T cast(V value) {
        return (T) value;
    }

    /**
     * 将输出对象转换为指定类型
     *
     * @param input
     * @param targetType
     * @return
     */
    @SuppressWarnings("unchecked")
    public static <T> T convertTo(Object input, Class<T> targetType) {
        return (T) convert(input, targetType);
    }

    @SuppressWarnings("unchecked")
    public static <T> T convertTo(Object input, TypeToken<T> targetType) {
        return (T) convert(input, targetType.getType());
    }

    @SuppressWarnings("unchecked")
    public static <T> T convertTo(Object input, Type targetType) {
        return (T) convert(input, targetType);
    }

    /**
     * 将指定对象转换为目标类实例
     *
     * @param input
     * @param targetType
     * @return
     */
    @SuppressWarnings({"unchecked", "rawtypes"})
    private static Object convert(Object input, Type targetType) {

        if (input == null) {
            return null;
        }

        if (targetType == null) {
            return null;
        }

        Class inputClass = input.getClass();
        if (inputClass.isArray()) { // 数组

            Class inputComponentType = inputClass.getComponentType();

            if (TypeUtils.isArrayType(targetType)) {// 目标是数组

                Type targetComponentType = TypeUtils.getArrayComponentType(targetType);
                Class targetComponentClass = TypeUtils.getRawType(targetComponentType, inputComponentType);
                int len = Array.getLength(input);
                Object arr = Array.newInstance(targetComponentClass, len);
                for (int i = 0; i < len; i++) {
                    Object o = Array.get(input, i);
                    Object v = convert(o, targetComponentType);
                    Array.set(arr, i, v);
                }

                return arr;

            } else if (TypeUtils.isAssignable(targetType, Collection.class)) {// 目标是集合

                int len = Array.getLength(input);
                Collection collection = (Collection) newCollection(targetType, len);

                TypeToken<?> subType = TypeToken.of(targetType);
                Type targetComponentType = subType.resolveType(Collection.class.getTypeParameters()[0]).getType();
                if (targetComponentType instanceof TypeVariable) {
                    // List list;
                    // 的情况
                    // 没有附带任何泛型
                    targetComponentType = ((TypeVariable) targetComponentType).getBounds()[0];
                }

                for (int i = 0; i < len; i++) {
                    Object o = Array.get(input, i);
                    Object v = convert(o, targetComponentType);
                    collection.add(v);
                }

                return collection;
            } else if (inputComponentType == byte.class) {
                if (targetType == String.class) {
                    try {
                        return new String((byte[]) input, Charset.defaultCharset());
                    } catch (Exception e) {
                        throw new RuntimeException(String.format("字符集编码 [%s] 构建 String !", Charset.defaultCharset()));
                    }
                }
            }

        } else if (Collection.class.isAssignableFrom(inputClass)) { // 集合

            Class inputComponentType = inputClass.getClass();

            if (TypeUtils.isArrayType(targetType)) {// 目标是数组

                Type targetComponentType = TypeUtils.getArrayComponentType(targetType);
                Class targetComponentClass = TypeUtils.getRawType(targetComponentType, inputComponentType);
                int len = Array.getLength(input);
                Object arr = Array.newInstance(targetComponentClass, len);
                int index = 0;
                for (Object o : (Collection) input) {
                    Object v = convert(o, targetComponentType);
                    Array.set(arr, index++, v);
                }
                return arr;

            } else if (TypeUtils.isAssignable(targetType, Collection.class)) {// 目标是集合

                Collection collection = (Collection) newCollection(targetType, ((Collection) input).size());
                TypeToken<?> subType = TypeToken.of(targetType);
                Type targetComponentType = subType.resolveType(Collection.class.getTypeParameters()[0]).getType();
                if (targetComponentType instanceof TypeVariable) {
                    targetComponentType = ((TypeVariable) targetComponentType).getBounds()[0];
                }

                for (Object o : (Collection) input) {
                    Object v = convert(o, targetComponentType);
                    collection.add(v);
                }

                return collection;
            }

        } else if (Map.class.isAssignableFrom(inputClass)) {// Map

            if (TypeUtils.isAssignable(targetType, Map.class)) {

                Map map = (Map) newCollection(targetType, ((Map) input).size());

                TypeToken<?> subType = TypeToken.of(targetType);

                Type keyType = subType.resolveType(Map.class.getTypeParameters()[0]).getType();
                if (keyType instanceof TypeVariable) {
                    keyType = ((TypeVariable) keyType).getBounds()[0];
                }
                Type valueType = subType.resolveType(Map.class.getTypeParameters()[1]).getType();
                if (valueType instanceof TypeVariable) {
                    valueType = ((TypeVariable) valueType).getBounds()[0];
                }

                for (Map.Entry<?, ?> entry : ((Map<?, ?>) input).entrySet()) {
                    Object key = convert(entry.getKey(), keyType);
                    Object value = convert(entry.getValue(), valueType);
                    map.put(key, value);
                }

                return map;
            }

        } else {

            if (targetType == byte.class || targetType == Byte.class) {
                return toByte(input);
            }
            if (targetType == short.class || targetType == Short.class) {
                return toShort(input);
            }
            if (targetType == int.class || targetType == Integer.class) {
                return toInt(input);
            }
            if (targetType == long.class || targetType == Long.class) {
                return toLong(input);
            }
            if (targetType == float.class || targetType == Float.class) {
                return toFloat(input);
            }
            if (targetType == double.class || targetType == Double.class) {
                return toDouble(input);
            }
            if (targetType == boolean.class || targetType == Boolean.class) {
                return toBoolean(input);
            }
            if (targetType == Object.class) {
                return input;
            }
            if (TypeUtils.isAssignable(targetType, Enum.class)) {
                return toEnum(input, (Class) targetType);
            }

            // 源是string 目标不是string
            if (input instanceof String && !TypeUtils.isAssignable(targetType, String.class)) {

                Converter converter = converters.get(targetType);
                if (converter != null) {
                    return converter.convertFrom(String.valueOf(input));
                }

                String content = (String) input;
                if (StringUtils.isBlank(content)) {
                    return null;
                }

                return GsonUtils.fromJson(content, targetType);
            }
        }

        if (TypeUtils.isInstance(input, targetType)) {
            return input;
        }

        throw new RuntimeException(String.format("无法从 [%s] 类型转换为 [%s]类型!", input.getClass(), targetType));
    }

    /**
     * 查询具体的集合类型
     *
     * @param type
     * @param size
     * @return
     */
    private static Object newCollection(Type type, int size) {
        if (TypeUtils.isAssignable(type, List.class)) {
            if (size >= 0) {
                return new ArrayList<>(size);
            } else {
                return new ArrayList<>();
            }
        } else if (TypeUtils.isAssignable(type, Set.class)) {
            if (size >= 0) {
                return new LinkedHashSet<>(size);
            } else {
                return new LinkedHashSet<>();
            }
        } else if (TypeUtils.isAssignable(type, Queue.class)) {
            return new LinkedList<>();
        } else if (TypeUtils.isAssignable(type, Map.class)) {
            if (size >= 0) {
                return new LinkedHashMap<>(size);
            } else {
                return new LinkedHashMap<>();
            }
        } else {
            throw new RuntimeException(String.format("无法识别的集合类型 [%s]!", type));
        }
    }
}
