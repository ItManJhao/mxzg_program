package com.ayjs.mxzg.common.util.gson.deserializer;

import com.google.common.reflect.TypeParameter;
import com.google.common.reflect.TypeToken;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;

import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.Collection;

abstract class BaseCollectionDeserializer<T> implements JsonDeserializer<T> {

    protected abstract T buildFrom(Collection<?> collection);

    @Override
    public T deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
        final Type[] typeArguments = ((ParameterizedType) typeOfT).getActualTypeArguments();
        final Type parameterizedType = collectionOf(TypeToken.of(typeArguments[0])).getType();
        final Collection<?> collection = context.deserialize(json, parameterizedType);
        return buildFrom(collection);
    }

    private static <E> TypeToken<Collection<E>> collectionOf(TypeToken<E> type) {
        return new TypeToken<Collection<E>>() {
        }
                .where(new TypeParameter<E>() {
                }, type);
    }
}
