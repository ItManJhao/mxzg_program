package com.ayjs.mxzg.config.excel.cache.magicTower;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.magicTower.CMagicTowerLevel;
import com.ayjs.mxzg.config.struct.MonsterTeamCheck;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 幻魔塔怪物mag
 *
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
@Component
public class MagicTowerLevelSysCache extends BaseExcelCache<CMagicTowerLevel> implements MonsterTeamCheck {

    private Map<Integer, List<CMagicTowerLevel>> missionMap = null;

    @Override
    protected void loadAfterReady() {
        missionMap = getAll().stream().collect(Collectors.groupingBy(CMagicTowerLevel::getMission_id));

    }

    @Override
    public String getFileName() {
        return "magictowerlevel";
    }

    public List<CMagicTowerLevel> getByMission(int mission) {
        return missionMap.get(mission);
    }

    @Override
    public List<List<CMagicTowerLevel>> getAllTeams() {
        List<List<CMagicTowerLevel>> result = new ArrayList<>();
        result.addAll(missionMap.values());
        return result;
    }
}
