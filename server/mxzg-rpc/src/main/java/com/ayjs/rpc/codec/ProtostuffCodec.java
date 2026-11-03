package com.ayjs.rpc.codec;

import org.springframework.stereotype.Component;

import com.ayjs.rpc.util.ProtostuffUtil;

/**
 * @author Alias
 * @date 2017年12月11日 下午4:45:08
 */
@Component
public class ProtostuffCodec implements RpcCodec {

    @Override
    public <T> byte[] encode(T obj) {
        return ProtostuffUtil.serialize(obj);
    }

    @Override
    public <T> T decode(Class<T> clazz, byte[] data) {
        return ProtostuffUtil.deserialize(data, clazz);
    }
}
