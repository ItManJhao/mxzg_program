package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CGoddessSkillRefine;
import org.springframework.stereotype.Component;

@Component
public class GoddessSkillRefineSysCache extends BaseExcelCache<CGoddessSkillRefine> {


	@Override
	public String getFileName() {
		return "goddessskillrefine";
	}

	public CGoddessSkillRefine getGoddessSkillRefine(int refineLevel){
		CGoddessSkillRefine cGoddessSkillRefine = null;
		for (CGoddessSkillRefine cModel : this.getAll()) {
			if (cModel.getLevel() == refineLevel) {
				cGoddessSkillRefine = cModel;
				break;
			}
		}
		return cGoddessSkillRefine;
	}

}