/**
 *
 */
package com.ayjs.mxzg.cross.module.clanworldboss.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.annotation.Subscribe.AsyncType;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.top.TopN;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.cross.module.clanworldboss.domain.ClanWorldBossMember;
import com.ayjs.mxzg.cross.module.clanworldboss.domain.ClanWorldBossStageControl;
import com.ayjs.mxzg.cross.module.clanworldboss.event.ClanWorldBossClanPointEvent;
import com.ayjs.mxzg.cross.module.clanworldboss.event.ClanWorldBossRolePointEvent;
import com.ayjs.mxzg.cross.module.crossservice.service.CrossServerGroupService;
import com.ayjs.mxzg.cross.module.rank.service.AbstractCrossRankService;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.CSClanWorldBossRoleRank;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.rpc.server.Connection;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Objects;

/**
 * @author YY
 *
 */
@Observer
@Service
public class ClanWorldBossRoleRankService extends AbstractCrossRankService<CSClanWorldBossRoleRank> {

    @Autowired
    private ClanWorldBossMemberService clanWorldBossMemberService;
    @Autowired
    private ClanWorldBossService clanWorldBossService;
    @Autowired
    private CrossServerGroupService crossServerGroupService;
    @Autowired
    private EventBus eventBus;

    @Override
    public CrossRankType getRankType() {
        return CrossRankType.CLAN_WORLD_BOSS_ROLE;
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(ClanWorldBossRolePointEvent event) {
        RankData newRank = new RankData();
        newRank.setRankId(event.getRid());
        newRank.setRankTime(event.getTime());
        newRank.setRankValue(event.getPoint());

        CrossGroup group = crossServerGroupService.getCrossGroup(event.getServerId());
        if (group != null) {
            addRank(newRank, group.getGroupId());
        }

        eventBus.post(ClanWorldBossClanPointEvent.of(event.getClanId(), event.getTime(), event.getServerId()));
    }

    public void removeRank(long rid, long clanId, int serverId) {
        // TODO
        CrossGroup group = crossServerGroupService.getCrossGroup(serverId);
        if (Objects.nonNull(group)) {
            RankData newRank = new RankData();
            newRank.setRankId(rid);
            removeRank(newRank, group.getGroupId());
        }
        eventBus.post(ClanWorldBossClanPointEvent.of(clanId, TimeDateUtil.getCurrentTimeInt(), serverId));
    }


    @Override
    protected Map<Integer, List<RankData>> startLoadRank() {
        ClanWorldBossStageControl stageControl = clanWorldBossService.getClanWorldBossStage();

        List<ClanWorldBossMember> memberList = clanWorldBossMemberService.getByRound(stageControl.getRound());
        Map<Integer, List<ClanWorldBossMember>> memberMap = ListMapUtil.fillListMap(memberList, ClanWorldBossMember::getServerId);

        Map<Integer, List<RankData>> rankMap = new HashMap<>();

        for (Entry<Integer, List<ClanWorldBossMember>> entry : memberMap.entrySet()) {
            int serverId = entry.getKey();
            if (serverId <= 0) {
                continue;
            }
            CrossGroup group = crossServerGroupService.getCrossGroup(serverId);
            if (group == null) {
                continue;
            }
            List<RankData> groupRankList = rankMap.get(group.getGroupId());
            if (groupRankList == null) {
                groupRankList = new ArrayList<>();
                rankMap.put(group.getGroupId(), groupRankList);
            }
            for (ClanWorldBossMember member : entry.getValue()) {
                if (member.getClanId() <= 0 || member.getRound() != stageControl.getRound()) {
                    continue;
                }
                RankData rank = new RankData();
                rank.setRankId(member.getRid());
                rank.setRankTime(member.getPointTime());
                rank.setRankValue(member.getPoint());
                groupRankList.add(rank);
            }
        }
        return rankMap;
    }

    public int getMaxRank(int serverId) {
        CrossGroup crossGroup = crossServerGroupService.getCrossGroup(serverId);
        if (crossGroup == null) {
            return 0;
        }
        TopN<Long, RankData> topN = this.groupTopN.get(crossGroup.getGroupId());
        if (topN == null) {
            return 0;
        }
        return topN.size();
    }


    @Override
    public List<CSClanWorldBossRoleRank> getAll(int serverGroup) {
        return Collections.emptyList();
    }

    @Override
    public void pullToAllGame() {

    }

    @Override
    public void pullToGame(int serverId, Connection connection) {

    }
}
