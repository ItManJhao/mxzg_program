package com.ayjs.mxzg.common.util.gson.deserializer;

import com.google.common.collect.ImmutableSet;

import java.util.Collection;

public class ImmutableSetDeserializer extends BaseCollectionDeserializer<ImmutableSet<?>> {

    @Override
    protected ImmutableSet<?> buildFrom(Collection<?> collection) {
        return ImmutableSet.copyOf(collection);
    }

}