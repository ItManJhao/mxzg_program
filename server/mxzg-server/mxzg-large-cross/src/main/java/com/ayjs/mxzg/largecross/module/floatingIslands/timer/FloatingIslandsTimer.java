package com.ayjs.mxzg.largecross.module.floatingIslands.timer;

import com.ayjs.mxzg.common.top.TopN;
import com.ayjs.mxzg.config.excel.constant.FloatingIslandsConst;
import com.ayjs.mxzg.config.struct.FloatingIslandsStage;
import com.ayjs.mxzg.largecross.module.floatingIslands.domain.RoleFloatingIslands;
import com.ayjs.mxzg.largecross.module.floatingIslands.service.FloatingIslandsRankService;
import com.ayjs.mxzg.largecross.module.floatingIslands.service.FloatingIslandsService;
import com.ayjs.mxzg.message.module.floatingIslands.struct.FloatingIslandsTime;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.role.dao.CrossRoleRedisDao;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/7/3
 **/
@Service
public class FloatingIslandsTimer extends AbstractCronTask {

    @Autowired
    private FloatingIslandsService floatingIslandsService;
    @Autowired
    private CrossRoleRedisDao crossRoleRedisDao;
    @Autowired
    private FloatingIslandsRankService floatingIslandsRankService;
    @Autowired
    private FloatingIslandsConst floatingIslandsConst;

    @Override
    public Object identity() {
        return "FloatingIslandsTimer";
    }

    @Override
    public String expression() {
        return "0 0/10 * * * ?";
    }

    @Override
    public void run() {
        FloatingIslandsTime time = floatingIslandsService.getTime();
        if (time.getStage() != FloatingIslandsStage.CHALLENGE_BOSS.getCode()) {
            return;
        }
        Map<Integer, TopN<Long, RankData>> groupTopN = floatingIslandsRankService.getGroupTopN();

        List<Long> updateRoles = new ArrayList<>();
        groupTopN.forEach((group, topN) -> {
            List<RankData> top = topN.top(floatingIslandsConst.getShowCount());
            updateRoles.addAll(top.stream().mapToLong(RankData::getRankId).collect(ArrayList::new, ArrayList::add, ArrayList::addAll));
        });

        if (updateRoles.size() > 0) {
            List<CrossRole> crossRoles = crossRoleRedisDao.get(updateRoles);
            crossRoles.forEach(crossRole -> {
                        RoleFloatingIslands roleFloatingIslands = floatingIslandsService.getRoleFloatingIslands(crossRole.getId());
                        if (roleFloatingIslands != null) {
                            floatingIslandsService.setRoleInfo(crossRole, roleFloatingIslands);
                            floatingIslandsService.update(roleFloatingIslands);
                        }
                    }
            );
        }

    }
}
