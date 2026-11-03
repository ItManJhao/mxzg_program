package com.ayjs.mxzg.config.converter;

import java.util.Collections;
import java.util.List;

import org.springframework.stereotype.Component;

import com.alibaba.druid.util.StringUtils;
import com.alibaba.fastjson.JSONArray;
import com.ayjs.mxzg.common.convert.Converter;


@Component
public class ListIntegerConverter implements Converter<List<Integer>> {

	@Override
	public List<Integer> convertFrom(String content) {
		if(StringUtils.isEmpty(content)){
			return Collections.emptyList();
		}
		try{
			return JSONArray.parseArray(content, Integer.class);
		} catch (Exception e) {
			throw new RuntimeException(String.format("字符串{%s}转换List<Integer>类型失败", content));
		}
	}

}
