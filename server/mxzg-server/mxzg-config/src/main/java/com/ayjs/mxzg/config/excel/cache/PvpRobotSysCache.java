/**
 *
 */
package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CPvpRobot;
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
public class PvpRobotSysCache extends BaseExcelCache<CPvpRobot> implements MonsterTeamCheck {

    private Map<Integer, List<CPvpRobot>> teamRobotMap;

    @Override
    public String getFileName() {
        return "pvprobot";
    }

    @Override
    protected void loadAfterReady() {
        this.teamRobotMap = this.fillListMap(CPvpRobot::getTeam);
    }

    public List<CPvpRobot> getByTeam(int team) {
        return teamRobotMap.get(team);
    }

    @Override
    public List<List<CPvpRobot>> getAllTeams() {
        return ImmutableList.copyOf(teamRobotMap.values());
    }
}
