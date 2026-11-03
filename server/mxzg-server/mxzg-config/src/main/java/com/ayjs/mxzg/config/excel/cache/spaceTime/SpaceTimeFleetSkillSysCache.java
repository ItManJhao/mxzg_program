package com.ayjs.mxzg.config.excel.cache.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeFleetSkill;
import org.springframework.stereotype.Component;

import java.util.Map;

@Component
public class SpaceTimeFleetSkillSysCache extends BaseExcelCache<CSpaceTimeFleetSkill> {

    //<科技类型，<等级，>>
    private Map<Integer, Map<Integer, CSpaceTimeFleetSkill>> map;

    @Override
    protected void loadAfterReady() {
        this.map = this.fillTwoLayerMap(CSpaceTimeFleetSkill::getType, CSpaceTimeFleetSkill::getLevel);
    }

    /**
     * 获取该类型技能最大等级
     *
     * @param type
     * @return
     */
    public int maxLevel(int type) {
        Map<Integer, CSpaceTimeFleetSkill> typeMap = map.get(type);
        ConfigAsserts.notNull(typeMap, () -> String.format("CSpaceTimeFleetSkill不存在科技类型{%s}", type));
        return typeMap.keySet().stream().max(Integer::compareTo).orElse(0);
    }

    public CSpaceTimeFleetSkill getSkill(int type, int level) {
        Map<Integer, CSpaceTimeFleetSkill> typeMap = map.get(type);
        ConfigAsserts.notNull(typeMap, () -> String.format("CSpaceTimeFleetSkill不存在科技类型{%s}", type));
        CSpaceTimeFleetSkill cSpaceTimeFleetSkill = typeMap.get(level);
        ConfigAsserts.notNull(typeMap, () -> String.format("CSpaceTimeFleetSkill不存在科技类型{%s}等级{%s}", type, level));
        return cSpaceTimeFleetSkill;
    }

    @Override
    public String getFileName() {
        return "spacetimefleetskill";
    }
}
