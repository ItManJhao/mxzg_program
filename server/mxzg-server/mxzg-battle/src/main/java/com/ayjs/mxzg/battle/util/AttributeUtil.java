package com.ayjs.mxzg.battle.util;

import java.util.HashMap;
import java.util.Map;

import com.ayjs.mxzg.battle.BattleConstant;
import com.ayjs.mxzg.config.struct.AttributeType;

/**
 * 属性帮助类
 * @author meiyc
 *
 */
public class AttributeUtil {

	/**
	 * 增加百分比
	 * @param baseValue
	 * @param percent
	 * @return
	 */
	public static long addPercent(long baseValue, long percent){
		return (long)(baseValue * calPercent(percent));
	}
	
	/**
	 * 计算增加百分比后的值
	 * @param baseValue
	 * @param percent
	 * @return
	 */
	public static double calPercent(long baseValue, long percent){
		return baseValue * calPercent(percent);
	}
	
	/**
	 * 计算百分比值
	 * @param percentValue
	 * @return
	 */
	public static double calPercent(long percentValue){
		return percentValue / BattleConstant.PERCENTAGE_RATIO;
	}
	
	/**
	 * 计算属性并返回新的属性列表
	 * @return
	 */
	public static Map<AttributeType, Long> calAllAttribute(Map<AttributeType, Long> baseAttribute, Map<AttributeType, Long> addition){
		Map<AttributeType, Long> newAttributes = new HashMap<>();
		baseAttribute.keySet().forEach(type->{
			long baseValue = baseAttribute.get(type);
			AttributeType percentType = type == AttributeType.HP ? AttributeType.HP_PERCENT : type.getPercent();
			double basePercent = percentType == null ? 1 : 1 + AttributeUtil.calPercent(addition.getOrDefault(percentType, 0L));
			baseValue *= basePercent;
			newAttributes.put(type, baseValue);
		});
		return newAttributes;
	}
}
