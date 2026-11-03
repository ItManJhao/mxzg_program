package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CWorldLevelGainExp;
import com.ayjs.mxzg.config.struct.ThingBonus;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * 世界等级加成
 *
 * @author hyx
 */
@Component
public class WorldLevelGainExpSysCache extends BaseExcelCache<CWorldLevelGainExp> {

    @Override
    public String getFileName() {
        return "worldlevelgainexp";
    }

    /**
     * 获取当前世界等级增益效果
     *
     * @param level
     * @return
     */
    public List<ThingBonus> getWorldLevelGain(int level) {
        List<ThingBonus> bonusList = new ArrayList<>();
        for (CWorldLevelGainExp config : getAll()) {
            if (config.getLevel_down() <= level && config.getLevel_up() >= level) {
                bonusList.addAll(config.getBonus());
                break;
            }
        }
        return bonusList;
    }

}
