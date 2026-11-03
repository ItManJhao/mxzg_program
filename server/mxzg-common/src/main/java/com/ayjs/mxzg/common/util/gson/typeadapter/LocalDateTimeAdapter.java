package com.ayjs.mxzg.common.util.gson.typeadapter;


import cn.hutool.core.date.DatePattern;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;
import lombok.extern.slf4j.Slf4j;

import java.lang.reflect.Type;
import java.time.LocalDateTime;
import java.util.Objects;

@Slf4j
public class LocalDateTimeAdapter implements JsonSerializer<LocalDateTime>, JsonDeserializer<LocalDateTime> {

    private static String LOCAL_DATE_TIME_DATE = "date";
    private static String LOCAL_DATE_TIME_TIME = "time";

    private static String LOCAL_DATE_YEAR = "year";
    private static String LOCAL_DATE_MONTH = "month";
    private static String LOCAL_DATE_DAY = "day";

    private static String LOCAL_TIME_HOUR = "hour";
    private static String LOCAL_TIME_MINUTE = "minute";
    private static String LOCAL_TIME_SECOND = "second";
    private static String LOCAL_TIME_NANO = "nano";


    @Override
    public JsonElement serialize(LocalDateTime src, Type typeOfSrc, JsonSerializationContext context) {
        return new JsonPrimitive(src.format(DatePattern.NORM_DATETIME_FORMATTER));
    }

    @Override
    public LocalDateTime deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
        if (json.isJsonPrimitive()) {
            String datetime = json.getAsJsonPrimitive().getAsString();
            return LocalDateTime.parse(datetime, DatePattern.NORM_DATETIME_FORMATTER);
        } else {
            JsonObject asJsonObject = json.getAsJsonObject();
            JsonObject date = null;
            JsonObject time = null;
            if (asJsonObject.has(LOCAL_DATE_TIME_DATE)) {
                date = asJsonObject.get(LOCAL_DATE_TIME_DATE).getAsJsonObject();
            }
            if (asJsonObject.has(LOCAL_DATE_TIME_TIME)) {
                time = asJsonObject.get(LOCAL_DATE_TIME_TIME).getAsJsonObject();
            }
            if (Objects.isNull(date) || Objects.isNull(time)) {
                return LocalDateTime.MIN;
            }
            return LocalDateTime.of(date.get(LOCAL_DATE_YEAR).getAsInt(),
                    date.get(LOCAL_DATE_MONTH).getAsInt(),
                    date.get(LOCAL_DATE_DAY).getAsInt(),
                    time.get(LOCAL_TIME_HOUR).getAsInt(),
                    time.get(LOCAL_TIME_MINUTE).getAsInt(),
                    time.get(LOCAL_TIME_SECOND).getAsInt(),
                    time.get(LOCAL_TIME_NANO).getAsInt());
        }
    }

}
