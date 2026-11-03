package com.ayjs.mxzg.config.converter;

import com.alibaba.druid.util.StringUtils;
import com.ayjs.mxzg.common.convert.Converter;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;


@Component
public class LocalDateTimeConverter implements Converter<LocalDateTime> {

	@Override
	public LocalDateTime convertFrom(String content) {
		if(StringUtils.isEmpty(content)){
			return null;
		}
		try{
			return LocalDateTime.parse(content);
		} catch (Exception e) {
			throw new RuntimeException(String.format("字符串{%s}转换LocalDateTime类型失败", content));
		}
	}

}
