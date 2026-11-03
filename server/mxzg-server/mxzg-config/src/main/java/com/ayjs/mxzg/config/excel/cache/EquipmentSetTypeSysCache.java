package com.ayjs.mxzg.config.excel.cache;


import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CEquipmentSetType;

@Component
public class EquipmentSetTypeSysCache extends BaseExcelCache<CEquipmentSetType> {


	@Override
	public String getFileName() {
		return "equipmentsettype";
	}

	/**
	 * 根据套装类型获取所有的套装属性
	 * @param setType
	 * @param suitCount
	 * @return
	 */
	public List<CEquipmentSetType> getEquipmentSetBy(int setType, int suitCount){
		return getAll().stream().filter(set-> set.getType() == setType && set.getNum() <= suitCount).collect(Collectors.toList());
	}

}