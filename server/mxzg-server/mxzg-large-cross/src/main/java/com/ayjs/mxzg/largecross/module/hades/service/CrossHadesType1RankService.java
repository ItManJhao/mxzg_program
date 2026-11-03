package com.ayjs.mxzg.largecross.module.hades.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.largecross.module.hades.domain.CrossHades;
import com.ayjs.mxzg.largecross.module.hades.event.HadesChallengeEvent;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

/**
 * @Author: CWJ
 * @Date: 2021/1/6
 **/
@Service
@Observer
@Slf4j
public class CrossHadesType1RankService extends AbstractCrossHadesRankService {
    @Override
    public CrossRankType getRankType() {
        return CrossRankType.HADES_TYPE_1;
    }

    @Subscribe
    public void listen(HadesChallengeEvent event) {
        if (getHadesType().getNumber() == event.getType()) {
            CrossRole crossrole = crossRoleRedisDao.get(event.getRid());
            CrossGroup group = crossServerGroupDao.get().getGroupByServerId(crossrole.getServerId());
            if (group == null) {
                log.error("服务器[{}]没有分组", crossrole.getServerId());
                return;
            }

            CrossHades crossHades = crossHadesService.get(event.getRid());
            RankData crossRank = new RankData();
            crossRank.setRankId(crossHades.getRid());
            crossRank.setRankTime(crossHades.getRankTimeByType(getHadesType().getNumber()));
            crossRank.setRankValue(crossHades.getFloorByType(getHadesType().getNumber()));
            addRank(crossRank, group.getGroupId());
//            messageHelper.pushToGroupMessage(group.getGroupId(), HadesUpdateRankMessage.of(getAll(group.getGroupId())));
        }
    }


}
