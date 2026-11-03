/**
 *
 */
package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CClanWorldBossMission;
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
public class ClanWorldBossMissionSysCache extends BaseExcelCache<CClanWorldBossMission> implements MonsterTeamCheck {

    private Map<Integer, List<CClanWorldBossMission>> turnsMissionMap;

    private List<CClanWorldBossMission> lastMission;

    @Override
    public String getFileName() {
        return "clanworldbossmission";
    }

    @Override
    protected void loadAfterReady() {
        this.turnsMissionMap = this.fillListMap(CClanWorldBossMission::getTurn);
        int turns = 0;

        for (int elem : turnsMissionMap.keySet()) {
            if (elem > turns) {
                turns = elem;
            }
        }
        this.lastMission = turnsMissionMap.get(turns);
    }

    public List<CClanWorldBossMission> getByRound(int round) {
        List<CClanWorldBossMission> list = turnsMissionMap.get(round);
        if (list == null) {
            return lastMission;
        }
        return list;
    }

    @Override
    public List<List<CClanWorldBossMission>> getAllTeams() {
        return ImmutableList.copyOf(turnsMissionMap.values());
    }
}
