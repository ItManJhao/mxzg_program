package com.ayjs.mxzg.gameserver.module.crusadegroup.group.handler;

import com.ayjs.mxzg.config.excel.cache.crusadegroup.CrusadeGroupBuildSysCache;
import com.ayjs.mxzg.config.excel.cache.crusadegroup.CrusadeGroupMapSysCache;
import com.ayjs.mxzg.config.excel.cache.occupation.OccupationSysCache;
import com.ayjs.mxzg.config.excel.constant.CrusadeGroupConst;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupBuild;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupMap;
import com.ayjs.mxzg.config.excel.entity.occupation.COccupation;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.CrusadeGroupHero;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.RoleCrusadeGroup;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Collection;

@Component
public class CrusadeGroupHelper {

    @Autowired
    private CrusadeGroupMapSysCache crusadeGroupMapSysCache;
    @Autowired
    private OccupationSysCache occupationSysCache;
    @Autowired
    private CrusadeGroupBuildSysCache crusadeGroupBuildSysCache;


    /**
     * 刷新生成效率
     * @param roleCrusadeGroup
     */
    public void refreshProductivity(RoleCrusadeGroup roleCrusadeGroup){
        int productivity = calProductivity(roleCrusadeGroup.getTerritoryInfo().keySet());
        roleCrusadeGroup.setProductivity(productivity);
    }

    /**
     * 计算生产效率
     * @return
     */
    public int calProductivity(Collection<Integer> territoryIds){
        int totalProductivity = 0;
        for (Integer territoryId : territoryIds) {
            CCrusadeGroupMap map = crusadeGroupMapSysCache.getMap(territoryId);
            CCrusadeGroupBuild crusadeGroupBuild = crusadeGroupBuildSysCache.getBuild(map.getArea_level(), map.getBuilding_level(), map.getFight_type());
            totalProductivity += crusadeGroupBuild.getCream_output();
        }
        return totalProductivity;
    }

    /**
     * 刷新英雄背包
     * @param roleCrusadeGroup
     */
    public void refreshHeroBackpack(RoleCrusadeGroup roleCrusadeGroup){
        COccupation occupation = occupationSysCache.getById(roleCrusadeGroup.getKnighthoodId());
        for(int i = roleCrusadeGroup.getHeroes().size() + 1; i <= occupation.getHeroNum(); i++){
            CrusadeGroupHero hero = CrusadeGroupHero.createOfBox(i, CrusadeGroupConst.CRUSADE_GROUP_INIT_ENERGY);
            roleCrusadeGroup.addHero(hero);
        }
    }

}
