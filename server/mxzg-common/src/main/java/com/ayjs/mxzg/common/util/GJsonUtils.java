package com.ayjs.mxzg.common.util;

import com.ayjs.mxzg.common.util.gson.deserializer.ImmutableListDeserializer;
import com.ayjs.mxzg.common.util.gson.deserializer.ImmutableMapDeserializer;
import com.ayjs.mxzg.common.util.gson.deserializer.ImmutableSetDeserializer;
import com.ayjs.mxzg.common.util.gson.deserializer.ImmutableSortedMapDeserializer;
import com.ayjs.mxzg.common.util.gson.deserializer.ImmutableSortedSetDeserializer;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.ImmutableSortedMap;
import com.google.common.collect.ImmutableSortedSet;
import com.google.common.reflect.TypeToken;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.io.Reader;
import java.lang.reflect.Type;

/**
 * gson工具
 */
@Deprecated
public class GJsonUtils {

    private static final Gson gson;

    static {
        gson = new GsonBuilder()
                .registerTypeAdapter(ImmutableList.class, new ImmutableListDeserializer())
                .registerTypeAdapter(ImmutableSet.class, new ImmutableSetDeserializer())
                .registerTypeAdapter(ImmutableMap.class, new ImmutableMapDeserializer())
                .registerTypeAdapter(ImmutableSortedSet.class, new ImmutableSortedSetDeserializer())
                .registerTypeAdapter(ImmutableSortedMap.class, new ImmutableSortedMapDeserializer())
                // 已经有历史数据，这个暂时屏蔽
//				.registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
//				.registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                .create();
    }

    @Deprecated
    public static <T> T fromJson(String json, Class<T> classOfT) {
        return gson.fromJson(json, classOfT);
    }

    @Deprecated
    public static <T> T fromJson(String json, Type typeOfT) {
        return gson.fromJson(json, typeOfT);
    }

    @Deprecated
    public static <T> T fromJson(String json, TypeToken<T> typeOfT) {
        return gson.fromJson(json, typeOfT.getType());
    }

    @Deprecated
    public static <T> T fromJson(Reader json, Class<T> classOfT) {
        return gson.fromJson(json, classOfT);
    }

    @Deprecated
    public static <T> T fromJson(Reader json, TypeToken<T> typeOfT) {
        return gson.fromJson(json, typeOfT.getType());
    }

    @Deprecated
    public static String toJson(Object src) {
        return gson.toJson(src);
    }
}
