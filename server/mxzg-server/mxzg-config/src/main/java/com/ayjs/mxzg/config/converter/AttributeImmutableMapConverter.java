package com.ayjs.mxzg.config.converter;

import java.util.List;

import org.springframework.stereotype.Component;

import com.alibaba.druid.util.StringUtils;
import com.alibaba.fastjson.JSONObject;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.convert.Converter;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.google.common.collect.ImmutableMap;

/**
 * 不可变的属性Map集合
 * @author meiyc
 *
 */
@Component
public class AttributeImmutableMapConverter implements Converter<ImmutableMap<AttributeType, Long>>{

	@Override
	public ImmutableMap<AttributeType, Long> convertFrom(String content) {
		if(StringUtils.isEmpty(content)){
			return ImmutableMap.of();
		}
		List<JSONObject> attributeList = JsonUtil.getList(content, JSONObject.class);
		ImmutableMap.Builder<AttributeType, Long> attributes = ImmutableMap.builder();
		attributeList.forEach(obj -> {
			for(String key : obj.keySet()) {
				Object value = obj.get(key);
				AttributeType type = ConvertUtils.toEnum(key, AttributeType.class);
				attributes.put(type, Long.parseLong(value.toString()));
			}
		});
		return attributes.build();
	}
}
