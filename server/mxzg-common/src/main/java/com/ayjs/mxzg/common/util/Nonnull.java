package com.ayjs.mxzg.common.util;

import com.ayjs.mxzg.common.exception.ErrorCodeException;

import java.util.*;
import java.util.function.Function;
import java.util.function.Supplier;

/**
 * 非空处理
 *
 * @author meiyc
 */
public class Nonnull {

    /**
     * 验证value是否为null，不为null则返回value，否则抛出错误码errorCode
     *
     * @param value
     * @param errorCode
     * @return
     */
    public static <T> T orThrow(T value, int errorCode) {
        if (value != null) {
            return value;
        }
        throw new ErrorCodeException(errorCode, "");
    }

    /**
     * 验证value是否为null，不为null则返回value，否则抛出异常
     *
     * @param value
     * @return
     */
    public static <T> T orThrow(T value) {
        if (value != null) {
            return value;
        }
        throw new RuntimeException();
    }

    /**
     * 验证value是否为null，不为null则返回value，否则取值supplier.get()
     *
     * @param value
     * @param supplier
     * @return
     */
    public static <T> T or(T value, Supplier<? extends T> supplier) {
        if (value != null) {
            return value;
        }
        return supplier.get();
    }

    /**
     * 验证value是否为null，不为null则返回value如果为null则取值defaultValue
     *
     * @param value
     * @param defaultValue
     * @return
     */
    public static <T> T or(T value, T defaultValue) {
        if (value != null) {
            return value;
        }
        return defaultValue;
    }

    /**
     * 检查collection 是否为null，为null则返回defaultCollection
     * @param collection
     * @param defaultCollection
     * @param <T>
     * @return
     */
    public static <T> Collection<T> or(Collection<T> collection, Collection<T> defaultCollection){
        return collection == null ? defaultCollection : collection;
    }

    /**
     * list 是否为null，为null则返回Collections.emptyList()
     * @param list
     * @param <T>
     * @return
     */
    public static <T> List<T> orEmpty(List<T> list){
        return list == null ? Collections.emptyList() : list;
    }

    /**
     * 检查collection 是否为null，为null则返回Collections.emptySet()
     * @param set
     * @param <T>
     * @return
     */
    public static <T> Set<T> orEmpty(Set<T> set){
        return set == null ? Collections.emptySet() : set;
    }

    /**
     * map 是否为null，为null则返回Collections.emptyMap()
     * @param map
     * @param <K>
     * @param <V>
     * @return
     */
    public static <K, V> Map<K, V> orEmpty(Map<K, V> map){
        return map == null ? Collections.emptyMap() : map;
    }

    /**
     * 验证value是否为null如果为null则返回null否则取值function.apply(value)
     *
     * @param value
     * @return
     */
    public static <T, R> R checkOr(T value, Function<T, ? extends R> function) {
        if (value != null) {
            return function.apply(value);
        }
        return null;
    }
}
