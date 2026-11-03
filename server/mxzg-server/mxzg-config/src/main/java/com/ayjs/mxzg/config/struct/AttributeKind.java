package com.ayjs.mxzg.config.struct;

import lombok.Getter;
import lombok.Setter;

/**
 * 属性信息
 * @author meiyc
 *
 */
@Getter
@Setter
public class AttributeKind {

	/** 属性类型 */
	private int type;
	
	/** 属性值 */
	private long value;
	
	/** {@link KindType} */
	private int kind;
	
	public static AttributeKind valueOf(int type, long value, int kindType){
		AttributeKind attributeKind = new AttributeKind();
		attributeKind.setType(type);
		attributeKind.setValue(value);
		attributeKind.setKind(kindType);
		return attributeKind;
	}
	
	
}
