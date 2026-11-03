package com.ayjs.mxzg.config.struct;


import com.ayjs.mxzg.common.convert.annotation.EnumMode;
import com.ayjs.mxzg.common.convert.annotation.ValueMode;

import lombok.Getter;

/**
 * 元素
 * @author meiyc
 *
 */
@Getter
@EnumMode(ValueMode.VALUE)
public enum Element {

	/** 火 */
	FIRE(1){
		@Override
		public AttributeType getDamageAddAttribute() {
			return AttributeType.FIRE_DAMAGE_ADD_PERCENT;
		}
	},
	
	/** 水 */
	WATER(2){
		@Override
		public AttributeType getDamageAddAttribute() {
			return AttributeType.WATER_DAMAGE_ADD_PERCENT;
		}
	},
	
	/** 木 */
	WOOD(3){
		@Override
		public AttributeType getDamageAddAttribute() {
			return AttributeType.WOOD_DAMAGE_ADD_PERCENT;
		}
	},
	
	/** 光 */
	LIGHT(4){
		@Override
		public AttributeType getDamageAddAttribute() {
			return AttributeType.LIGHT_DAMAGE_ADD_PERCENT;
		}
	},
	
	/** 暗 */
	DARK(5){
		@Override
		public AttributeType getDamageAddAttribute() {
			return AttributeType.DARK_DAMAGE_ADD_PERCENT;
		}
	};
	
	
	private int value; 
	
	
	private Element(int value){
		this.value = value;
	}
	
	/**
	 * 根据value值获取元素枚举
	 * @param value
	 * @return
	 */
	public static Element valueOf(int value){
		for(Element element: Element.class.getEnumConstants()){
			if(element.getValue() == value){
				return element;
			}
		}
		throw new RuntimeException(String.format("错误的元素类型:%s", value));
	}

	/**
	 * 获取伤害加成的属性
	 * @return
	 */
	public abstract AttributeType getDamageAddAttribute();
	
}
