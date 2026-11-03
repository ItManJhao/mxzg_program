package com.ayjs.mxzg.config.excel.cache.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeBotRole;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Component
public class SpaceTimeBotRoleSysCache extends BaseExcelCache<CSpaceTimeBotRole> {

    private Map<Integer, List<CSpaceTimeBotRole>> botMap;

    @Override
    protected void loadAfterReady() {
        this.botMap = this.fillListMap(CSpaceTimeBotRole::getLevel);
    }

    @Override
    public String getFileName() {
        return "spacetimebotrole";
    }

    /**
     * 根据等级获得机器人
     *
     * @param level
     * @return
     */
    public List<CSpaceTimeBotRole> getBotList(int level) {
        List<CSpaceTimeBotRole> botList = botMap.get(level);
        ConfigAsserts.notNull(botList, () -> String.format("不存在等级{%s}敌方机器人", level));
        return botList;
    }

}
