/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.ClassUtil;
import lombok.Getter;

import java.util.Objects;

/**
 * @author YY
 *
 */
@Getter
public class CBattleAbility implements BaseExcelModel {
	private int type;
	private String name;
	private String note;
	private int data_type;
	
	@Override
	public int getExcelId() {
		return type;
	}
	
	public String getCamelName() {
		if (Objects.isNull(getName())) {
			return "";
		}
		String[] strs = getName().split("_");
		String camel = "";
		for(int i = 0; i < strs.length; i++) {
			if(i == 0) {
				camel = camel + strs[i];
			} else {
				camel = camel + ClassUtil.upperFirstFieldLetter(strs[i]);
			}
		}
		return camel;
	}
}
