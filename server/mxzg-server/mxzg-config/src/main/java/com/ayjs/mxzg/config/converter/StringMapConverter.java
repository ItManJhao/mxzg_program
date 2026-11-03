package com.ayjs.mxzg.config.converter;

import com.alibaba.druid.util.StringUtils;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.TypeReference;
import com.ayjs.mxzg.common.convert.Converter;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.Map;


@Component
public class StringMapConverter implements Converter<Map<String, String>> {

	@Override
	public Map<String, String> convertFrom(String content) {
		if(StringUtils.isEmpty(content)){
			return Collections.emptyMap();
		}
		try{
			TypeReference<Map<String, String>> typeReference = new TypeReference<Map<String, String>>(){};
			return JSONArray.parseObject(content, typeReference.getType());
		} catch (Exception e) {
			throw new RuntimeException(String.format("字符串{%s}转换Map<String, String>类型失败", content));
		}
	}

}
