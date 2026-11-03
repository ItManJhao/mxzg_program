package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CServerLadderRobot;
import com.ayjs.mxzg.config.struct.MonsterTeamCheck;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Component
public class ServerLadderRobotSysCache extends BaseExcelCache<CServerLadderRobot> implements MonsterTeamCheck {

    @Getter
    private Map<Integer, List<CServerLadderRobot>> teamMap = new HashMap<>();

    @Override
    protected void loadAfterReady() {
        teamMap = getAll().stream().collect(Collectors.groupingBy(CServerLadderRobot::getTeam));
    }

    @Override
    public String getFileName() {
        return "serverladderrobot";
    }

    public List<CServerLadderRobot> getTeam(int teamId) {
        return teamMap.getOrDefault(teamId, Collections.emptyList());
    }

    @Override
    public List<List<CServerLadderRobot>> getAllTeams() {
        return ImmutableList.copyOf(teamMap.values());
    }
}
