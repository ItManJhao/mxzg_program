package com.ayjs.mxzg.config.excel.cache.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeFleetDurability;
import org.springframework.stereotype.Component;

import java.util.Comparator;

@Component
public class SpaceTimeFleetDurabilitySysCache extends BaseExcelCache<CSpaceTimeFleetDurability> {

    /**
     * 根据耐久度获取deBuff
     *
     * @param durability
     * @return
     */
    public CSpaceTimeFleetDurability getConfig(int durability) {
        CSpaceTimeFleetDurability cSpaceTimeFleetDurability = getAll().stream().filter(config -> config.getDurability_down() >= durability)
                .min(Comparator.comparingInt(CSpaceTimeFleetDurability::getDurability_down)).orElse(null);
        ConfigAsserts.notNull(cSpaceTimeFleetDurability, String.format("CSpaceTimeFleetDurability不存在耐久度{%s}的配置信息", durability));
        return cSpaceTimeFleetDurability;
    }

    @Override
    public String getFileName() {
        return "spacetimefleetdurability";
    }
}

