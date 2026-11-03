package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CGoddessSkillCost;
import org.springframework.stereotype.Component;

@Component
public class GoddessSkillCostSysCache extends BaseExcelCache<CGoddessSkillCost> {


    @Override
    public String getFileName() {
        return "goddessskillcost";
    }



    public CGoddessSkillCost getGoddessSkillCost(int skillLevel){
        CGoddessSkillCost cModel = null;
        for (CGoddessSkillCost cGoddessSkillcost : this.getAll()) {
            if (cGoddessSkillcost.getLevel() == skillLevel) {
                cModel = cGoddessSkillcost;
                break;
            }
        }
        return cModel;
    }

}