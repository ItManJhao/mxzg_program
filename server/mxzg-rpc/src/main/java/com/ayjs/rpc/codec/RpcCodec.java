package com.ayjs.rpc.codec;

/**
 * 序列化
 *
 * @author Alias
 * @date 2017年12月11日 下午4:42:03
 */
public interface RpcCodec {

    /**
     * 序列化
     *
     * @param obj
     * @return
     */
    <T> byte[] encode(T obj);

    /**
     * 反序列化
     *
     * @param data
     * @return
     */
    <T> T decode(Class<T> clazz, byte[] data);
}
