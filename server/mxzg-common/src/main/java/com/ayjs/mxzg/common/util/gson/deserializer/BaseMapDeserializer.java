package com.ayjs.mxzg.common.util.gson.deserializer;

import com.google.common.reflect.TypeParameter;
import com.google.common.reflect.TypeToken;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;

import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.Map;

abstract class BaseMapDeserializer<T> implements JsonDeserializer<T> {

    protected abstract T buildFrom(Map<?, ?> map);

    @Override
    public T deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
        final Type[] typeArguments = ((ParameterizedType) typeOfT).getActualTypeArguments();
        final Type parameterizedType = mapOf(TypeToken.of(typeArguments[0]), TypeToken.of(typeArguments[1])).getType();
        final Map<?, ?> map = context.deserialize(json, parameterizedType);
        return buildFrom(map);
    }

    private static <K, V> TypeToken<Map<K, V>> mapOf(TypeToken<K> keyType, TypeToken<V> valueType) {
        return new TypeToken<Map<K, V>>() {
        }
                .where(new TypeParameter<K>() {
                }, keyType)
                .where(new TypeParameter<V>() {
                }, valueType);
    }
}
