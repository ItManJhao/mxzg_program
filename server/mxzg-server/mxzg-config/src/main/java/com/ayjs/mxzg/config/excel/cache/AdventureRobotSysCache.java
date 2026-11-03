package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CAdventureRobot;
import com.ayjs.mxzg.config.struct.MonsterTeamCheck;
import com.google.common.collect.ImmutableList;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 勇者试炼机器人
 */
@Component
public class AdventureRobotSysCache extends BaseExcelCache<CAdventureRobot> implements MonsterTeamCheck {

    @Override
    public String getFileName() {
        return "adventurerobot";
    }

    public List<CAdventureRobot> getAdventureRobot(int team) {
        return getAll().stream().filter(robotData -> robotData.getTeam() == team).collect(Collectors.toList());
    }

    @Override
    public List<List<CAdventureRobot>> getAllTeams() {
        return ImmutableList.copyOf(getAll().stream().collect(Collectors.groupingBy(CAdventureRobot::getTeam)).values());
    }
}
