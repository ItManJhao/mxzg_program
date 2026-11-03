/**
 *
 */
package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CChampionRobot;
import com.ayjs.mxzg.config.struct.MonsterTeamCheck;
import com.google.common.collect.ImmutableList;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * @author YY
 *
 */
@Component
public class ChampionRobotSysCache extends BaseExcelCache<CChampionRobot> implements MonsterTeamCheck {

    private Map<Integer, List<CChampionRobot>> teamMap;

    @Override
    public String getFileName() {
        return "championrobot";
    }

    @Override
    protected void loadAfterReady() {
        this.teamMap = this.fillListMap(CChampionRobot::getTeam);
    }

    public List<CChampionRobot> getByTeam(int team) {
        return teamMap.get(team);
    }


    @Override
    public List<List<CChampionRobot>> getAllTeams() {
        return ImmutableList.copyOf(teamMap.values());
    }
}
