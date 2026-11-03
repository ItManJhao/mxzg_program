package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CGoddessWashAttr;
import com.ayjs.mxzg.config.struct.AttributeType;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

@Component
public class GoddessWashAttrSysCache extends BaseExcelCache<CGoddessWashAttr> {

    private Map<Integer, CGoddessWashAttr> levelMap = new HashMap<>();
    private int maxLevel;

    @Override
    public String getFileName() {
        return "goddesswashattr";
    }

    @Override
    protected void loadAfterReady() {
        levelMap = this.fillOneLayerMap(CGoddessWashAttr::getWash_level);
        for (CGoddessWashAttr cModel : getAll()) {
            if (cModel.getWash_level() > maxLevel) {
                maxLevel = cModel.getWash_level();
            }
        }
    }


    public int getMaxLevel() {
        return maxLevel;
    }

    public CGoddessWashAttr getWashLevel(int washLevel){
        CGoddessWashAttr cGoddessWashAttr = levelMap.get(washLevel);
        ConfigAsserts.notNull(cGoddessWashAttr, () -> String.format("CGoddessWashAttr配置数据不存在洗炼等级:{%s}的配置", washLevel));
        return cGoddessWashAttr;
    }

    /**
     * 获取精炼等级加成属性
     *
     * @param refineLevel
     * @return
     */
    public Map<AttributeType, Long> getAbilityMap(int refineLevel) {
        Map<AttributeType, Long> abilityMap = new HashMap<>();
        getAll().stream().filter(config -> config.getWash_level() <= refineLevel && refineLevel > 0).forEach(config -> {
            for (Map.Entry<AttributeType, Long> map : config.getAbility().entrySet()) {
                abilityMap.put(map.getKey(), abilityMap.getOrDefault(map.getKey(), 0l) + map.getValue());
            }
        });
        return abilityMap;
    }
}
