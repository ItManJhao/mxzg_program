package com.ayjs.mxzg.common.util;

import com.google.common.reflect.TypeToken;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.Type;
import java.lang.reflect.TypeVariable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * 类型转换，提取
 */
public class TypeUtil {

    /**
     * 从子类解析出传给父类的类型参数
     *
     * @param subclass
     * @param superClass
     * @return
     */
    public static Class<?>[] resolveClassArguments(Class<?> subclass, Class<?> superClass) {
        TypeToken<?> child = TypeToken.of(subclass);
        TypeVariable<?>[] typeParameters = superClass.getTypeParameters();
        Class<?>[] types = new Class<?>[typeParameters.length];
        for (int i = 0; i < typeParameters.length; i++) {
            types[i] = child.resolveType(typeParameters[i]).getRawType();
        }
        return types;
    }

    /**
     * 从子类解析出传给父类的类型参数
     *
     * @param subclass
     * @param superClass
     * @return
     */
    public static Type[] resolveTypeArguments(Class<?> subclass, Class<?> superClass) {
        TypeToken<?> child = TypeToken.of(subclass);
        TypeVariable<?>[] typeParameters = superClass.getTypeParameters();
        Type[] types = new Type[typeParameters.length];
        for (int i = 0; i < typeParameters.length; i++) {
            types[i] = child.resolveType(typeParameters[i]).getType();
        }
        return types;
    }

    /**
     * 解析出指定的注解，当前类>父类>接口
     *
     * @param annotationType
     * @param classType
     * @return
     */
    public static <T extends Annotation> T resolveAnnotation(Class<T> annotationType, Class<?> classType) {
        if (annotationType == null || classType == null) {
            return null;
        }

        T annotation = classType.getAnnotation(annotationType);
        if (annotation == null) {
            Class<?> superClass = classType.getSuperclass();
            if (superClass != Object.class) {
                annotation = resolveAnnotation(annotationType, superClass);
            }
        }

        if (annotation == null) {
            Class<?>[] interfaces = classType.getInterfaces();
            for (Class<?> interfaceType : interfaces) {
                annotation = resolveAnnotation(annotationType, interfaceType);
                if (annotation != null)
                    break;
            }
        }

        return annotation;
    }

    /**
     * 解析出指定的注解的字段，包含父类（但不包含Object.class）
     *
     * @param annotationType
     * @param classType
     * @return
     */
    public static <T extends Annotation> List<Field> resolveAnnotationField(Class<T> annotationType, Class<?> classType) {
        if (annotationType == null || classType == null) {
            return java.util.Collections.emptyList();
        }

        List<Field> fields = new ArrayList<>();

        Arrays.asList(classType.getDeclaredFields()).forEach(field -> {
            if (field.getAnnotation(annotationType) != null) {
                fields.add(field);
            }
        });

        Class<?> superClass = classType.getSuperclass();
        if (superClass != Object.class) {
            fields.addAll(resolveAnnotationField(annotationType, superClass));
        }

        return fields;
    }

    /**
     * 是否是数值类型
     *
     * @param targetClazz
     * @return
     */
    public static boolean isNumberType(Class<?> targetClazz) {
        if (Number.class.isAssignableFrom(targetClazz)) {
            return true;
        }
        // 判断原始类,过滤掉特殊的基本类型
        if (targetClazz == boolean.class || targetClazz == void.class) {
            return false;
        }
        return targetClazz.isPrimitive();
    }
}
