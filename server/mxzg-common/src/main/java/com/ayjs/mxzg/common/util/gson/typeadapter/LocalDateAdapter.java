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
import java.time.LocalDate;

@Slf4j
public class LocalDateAdapter implements JsonSerializer<LocalDate>, JsonDeserializer<LocalDate> {

    private static String LOCAL_DATE_YEAR = "year";
    private static String LOCAL_DATE_MONTH = "month";
    private static String LOCAL_DATE_DAY = "day";

    @Override
    public JsonElement serialize(LocalDate src, Type typeOfSrc, JsonSerializationContext context) {
        return new JsonPrimitive(src.format(DatePattern.NORM_DATE_FORMATTER));
    }

    @Override
    public LocalDate deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
        if (json.isJsonPrimitive()) {
            String datetime = json.getAsJsonPrimitive().getAsString();
            return LocalDate.parse(datetime, DatePattern.NORM_DATE_FORMATTER);
        } else {
            JsonObject asJsonObject = json.getAsJsonObject();
            int year = 0;
            int month = 0;
            int day = 0;
            if (asJsonObject.has(LOCAL_DATE_YEAR)) {
                year = asJsonObject.get(LOCAL_DATE_YEAR).getAsInt();
            }
            if (asJsonObject.has(LOCAL_DATE_MONTH)) {
                month = asJsonObject.get(LOCAL_DATE_MONTH).getAsInt();
            }
            if (asJsonObject.has(LOCAL_DATE_DAY)) {
                day = asJsonObject.get(LOCAL_DATE_DAY).getAsInt();
            }
            if (year <= 0) {
                return LocalDate.MIN;
            }
            return LocalDate.of(year, month, day);
        }
    }
}
