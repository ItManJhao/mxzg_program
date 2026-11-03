/**
 *
 */
package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CRainbowMission;
import com.ayjs.mxzg.config.struct.MonsterTeamCheck;
import com.google.common.collect.ImmutableList;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.stream.Collectors;

/**
 * @author YY
 *
 */
@Component
public class RainbowMissionSysCache extends BaseExcelCache<CRainbowMission> implements MonsterTeamCheck {

    private Map<Integer, Map<Integer, List<CRainbowMission>>> typeLevelMap;

    private Map<Integer, List<CRainbowMission>> lastMissionMap;

    @Override
    public String getFileName() {
        return "rainbowmission";
    }

    @Override
    protected void loadAfterReady() {
        Map<Integer, Map<Integer, List<CRainbowMission>>> tempTypeLevelMap = new HashMap<>();
        for (CRainbowMission mission : this.getAll()) {
            Map<Integer, List<CRainbowMission>> levelMap = tempTypeLevelMap.get(mission.getRainbow_type());
            if (levelMap == null) {
                levelMap = new HashMap<>();
                tempTypeLevelMap.put(mission.getRainbow_type(), levelMap);
            }
            List<CRainbowMission> levelList = levelMap.get(mission.getLevel());
            if (levelList == null) {
                levelList = new ArrayList<>();
                levelMap.put(mission.getLevel(), levelList);
            }
            levelList.add(mission);
        }
        this.typeLevelMap = tempTypeLevelMap;

        //得到最大的关卡
        Map<Integer, List<CRainbowMission>> tempLastMissionMap = new HashMap<>();
        for (Entry<Integer, Map<Integer, List<CRainbowMission>>> entry : tempTypeLevelMap.entrySet()) {
            int maxMission = 0;
            List<CRainbowMission> missionList = null;
            for (Entry<Integer, List<CRainbowMission>> mission : entry.getValue().entrySet()) {
                if (mission.getKey() > maxMission) {
                    maxMission = mission.getKey();
                    missionList = mission.getValue();
                }
            }
            tempLastMissionMap.put(entry.getKey(), missionList);
        }
        this.lastMissionMap = tempLastMissionMap;
    }

    public List<CRainbowMission> getMission(int type, int level) {
        Map<Integer, List<CRainbowMission>> levelMap = typeLevelMap.get(type);
        ConfigAsserts.notNull(levelMap, () -> String.format("彩虹圣殿类型数据不存在{%s}{%s}", getFileName(), type));
        List<CRainbowMission> levelList = levelMap.get(level);
        if (levelList == null) {
            levelList = lastMissionMap.get(type);
        }
        ConfigAsserts.notNull(levelList, () -> String.format("彩虹圣殿类型等级数据不存在{%s}{%s}{%s}", getFileName(), type, level));
        return levelList;
    }

    @Override
    public List<List<CRainbowMission>> getAllTeams() {
        Map<String, List<CRainbowMission>> collect = getAll().stream().collect(Collectors.groupingBy(config -> config.getRainbow_type() + "-" + config.getLevel()));
        return ImmutableList.copyOf(collect.values());
    }
}
