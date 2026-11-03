package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CFormationAddition;
import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Multimap;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.List;

@Component
public class FormationAdditionSysCache extends BaseExcelCache<CFormationAddition> {

	private Multimap<Integer, CFormationAddition> map = ArrayListMultimap.create();

	@Override
	public String getFileName() {
		return "formationaddition";
	}

	@Override
	protected void loadAfterReady() {
		List<CFormationAddition> all = getAll();
		for (CFormationAddition cFormationAddition : all) {
			map.put(cFormationAddition.getType(), cFormationAddition);
		}
	}

	/**
	 * 根据阵法id获取加成列表
	 * @param formationId
	 * @return
	 */
	public Collection<CFormationAddition> getByType(int formationId){
		return this.map.get(formationId);
	}
}