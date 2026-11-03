package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.Element;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

/**
 * 英雄元素克制表
 * @author meiyc
 *
 */
@Getter
@Setter
public class CHeroElemMul  implements BaseExcelModel {

	/** 主键 */
	private int idx;
	
	/** 火 */
	private List<Integer> fire;
	
	/** 水 */
	private List<Integer> water;
	
	/** 木 */
	private List<Integer> wood;
	
	/** 光 */
	private List<Integer> light;
	
	/** 暗 */
	private List<Integer> dark;
	
	@Override
	public int getExcelId() {
		return idx;
	}
	
	/**
	 * 获取命中加成比例
	 * @param element
	 * @return
	 */
	public int getHitPercent(int element){
		return getRestraintValue(element, 1);
	}
	
	/**
	 * 获取伤害加成比例
	 * @param element
	 * @return
	 */
	public int getDamagePercent(int element){
		return getRestraintValue(element, 0);
	}

	/**
	 * 获取元素克制值
	 * @param element
	 * @return
	 */
	public int getRestraintValue(int element, int index){
		if(Element.FIRE.getValue() == element){
			return fire.get(index);
		} else if(Element.WATER.getValue() == element){
			return water.get(index);
		} else if(Element.WOOD.getValue() == element){
			return wood.get(index);
		} else if(Element.LIGHT.getValue() == element){
			return light.get(index);
		} else if(Element.DARK.getValue() == element){
			return dark.get(index);
		} else {
			return 10000;
		}
	}
	
}
