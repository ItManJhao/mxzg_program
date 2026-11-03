package com.ayjs.mxzg.common.convert;

/**
 * 转换器接口
 */
public interface Converter<T> {
    T convertFrom(String content);
}
