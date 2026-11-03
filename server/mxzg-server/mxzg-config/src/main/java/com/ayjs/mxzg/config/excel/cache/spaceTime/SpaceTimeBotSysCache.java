package com.ayjs.mxzg.config.excel.cache.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CPromotionTrafficPermit;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeBot;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Component
public class SpaceTimeBotSysCache extends BaseExcelCache<CSpaceTimeBot> {

    /**
     * <机器人id,阵型id,<英雄>>
     */
    private Map<Integer, Map<Integer, List<CSpaceTimeBot>>> botLineupMap;

    @Override
    protected void loadAfterReady() {
        Map<Integer, Map<Integer, List<CSpaceTimeBot>>> botLineupTem = new HashMap<>();
        for (CSpaceTimeBot cSpaceTimeBot : getAll()) {
            //以机器人id为key
            Map<Integer, List<CSpaceTimeBot>> lineupMap = botLineupTem.computeIfAbsent(
                    cSpaceTimeBot.getBot_id(), k -> new HashMap<>());

            //以阵型id为key
            List<CSpaceTimeBot> lineupList = lineupMap.computeIfAbsent(cSpaceTimeBot.getLineup_type(),
                    k -> new ArrayList<>());

            lineupList.add(cSpaceTimeBot);
        }

        botLineupMap = botLineupTem;
    }

    /**
     * 获取机器人阵容
     *
     * @param botId
     * @return
     */
    public Map<Integer, List<CSpaceTimeBot>> getMap(int botId) {
        Map<Integer, List<CSpaceTimeBot>> map = botLineupMap.get(botId);
        ConfigAsserts.notNull(map, String.format("敌方机器人{%s}不存在", botId));
        return map;
    }

    /**
     * 根据机器人id和阵容类型获取阵容
     *
     * @param botId
     * @param lineupType
     * @return
     */
    public List<CSpaceTimeBot> getLineUp(int botId, int lineupType) {
        Map<Integer, List<CSpaceTimeBot>> botMap = this.getMap(botId);
        return botMap.get(lineupType);
    }

    @Override
    public String getFileName() {
        return "spacetimebot";
    }
}
