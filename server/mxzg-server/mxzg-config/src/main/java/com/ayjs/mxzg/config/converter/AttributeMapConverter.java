package com.ayjs.mxzg.config.converter;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.alibaba.druid.util.StringUtils;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.convert.Converter;
import com.ayjs.mxzg.common.util.EnumUtils;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.config.struct.AttributeType;

/**
 * 属性转换器
 * @author meiyc
 *
 */
@Component
public class AttributeMapConverter implements Converter<Map<AttributeType, Integer>> {

	@Override
	public Map<AttributeType, Integer> convertFrom(String content) {
		if(StringUtils.isEmpty(content)){
			return Collections.emptyMap();
		}
		
		Map<String, Integer> attributeMap = JsonUtil.getMap(content, String.class, Integer.class);
		Map<AttributeType, Integer> attributes = new HashMap<>();
		attributeMap.forEach((key, value)->{
			AttributeType type = EnumUtils.getEnumByValue(AttributeType.class, ConvertUtils.toInt(key));
			attributes.put(type, value);
		});
		return attributes;
	}

}
