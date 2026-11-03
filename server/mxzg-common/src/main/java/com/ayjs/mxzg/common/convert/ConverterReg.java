package com.ayjs.mxzg.common.convert;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.base.IRegister;


@Component
public class ConverterReg implements IRegister<Converter<?>>{

	@Override
	public void registerBean(Converter<?> bean) {
		ConvertUtils.registerConverter(bean);
	}

}
