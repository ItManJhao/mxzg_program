package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CRobotFormation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@Component
public class RobotFormationSysCache extends BaseExcelCache<CRobotFormation> {


	@Override
	public String getFileName() {
		return "robotformation";
	}


    @Override
    protected void loadAfterReady() {
        List<CRobotFormation> all = getAll();
        CRobotFormation formation = null;
        for (CRobotFormation robotFormation : all) {
            if(formation != null){
                ConfigAsserts.isTrue(robotFormation.getFighting() >= formation.getFighting(), String.format("机器人阵容请按照战力顺序配置idx{}", robotFormation.getIdx()));
            }
            formation = robotFormation;
        }
    }

    /**
	 * 根据战力获取阵容配置列表
	 * @param fighting
	 * @return
	 */
	public List<CRobotFormation> getFormationsBy(int fighting){
		List<CRobotFormation> all = getAll();
		List<CRobotFormation> formations = new ArrayList<>();
		int lastFighting = 0;
		for (CRobotFormation formation : all) {
			if(formation.getFighting() < fighting){
                if(lastFighting != formation.getFighting()){
                    formations.clear();
                }
                formations.add(formation);
                lastFighting = formation.getFighting();
			} else {
				break;
			}
		}
		return formations;
	}

}