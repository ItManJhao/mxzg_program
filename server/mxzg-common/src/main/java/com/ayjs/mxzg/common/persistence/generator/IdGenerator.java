package com.ayjs.mxzg.common.persistence.generator;

/**
 * ID生成器接口
 */
public interface IdGenerator<T> {
    /**
     * 下一个id
     *
     * @return
     */
    T nextId();
}
