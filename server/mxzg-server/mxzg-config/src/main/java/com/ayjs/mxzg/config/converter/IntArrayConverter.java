package com.ayjs.mxzg.config.converter;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.convert.Converter;
import com.ayjs.mxzg.common.util.StringUtil;


/**
 * Integer[] 数组转换器
 * @author meiyc
 *
 */
@Component
public class IntArrayConverter implements Converter<Integer[]>{

	@Override
	public Integer[] convertFrom(String content) {
		return StringUtil.stringToArray(content, "|", Integer.class);
	}

}
