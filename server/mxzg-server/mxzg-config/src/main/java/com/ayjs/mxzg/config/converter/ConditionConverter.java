package com.ayjs.mxzg.config.converter;

import com.alibaba.druid.util.StringUtils;
import com.alibaba.fastjson.JSON;
import com.ayjs.mxzg.common.convert.Converter;
import com.ayjs.mxzg.config.struct.UnlockCondition;
import org.springframework.stereotype.Component;


@Component
public class ConditionConverter implements Converter<UnlockCondition> {

	@Override
	public UnlockCondition convertFrom(String content) {
		if(StringUtils.isEmpty(content)){
			return null;
		}
		try{
			return JSON.parseObject(content, UnlockCondition.class);
		} catch (Exception e) {
			throw new RuntimeException(String.format("字符串{%s}转换UnlockCondition类型失败", content));
		}
	}

}
