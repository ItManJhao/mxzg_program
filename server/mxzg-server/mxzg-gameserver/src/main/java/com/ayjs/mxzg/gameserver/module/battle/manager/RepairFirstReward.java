package com.ayjs.mxzg.gameserver.module.battle.manager;

import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.config.excel.cache.FirstRewardTowerSysCache;
import com.ayjs.mxzg.config.excel.cache.FirstrewardChapterSysCache;
import com.ayjs.mxzg.config.excel.entity.CFirstRewardTower;
import com.ayjs.mxzg.config.excel.entity.CFirstrewardChapter;
import com.ayjs.mxzg.gameserver.module.battle.dao.RoleMissionDao;
import com.ayjs.mxzg.gameserver.module.battle.domain.RoleMission;
import com.ayjs.mxzg.gameserver.module.tower.dao.TowerDao;
import com.ayjs.mxzg.gameserver.module.tower.domain.Tower;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.List;

@Component
public class RepairFirstReward implements Lifecycle {

    @Autowired
    private TowerDao towerDao;
    @Autowired
    private RoleMissionDao roleMissionDao;
    @Autowired
    private FirstrewardChapterSysCache firstrewardChapterSysCache;
    @Autowired
    private FirstRewardTowerSysCache firstRewardTowerSysCache;

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf("REPAIR_FIRST_REWARD");
    }

    @Override
    public void start() throws Exception {
        List<RoleMission> list = roleMissionDao.listAll();
        for (RoleMission roleMission : list) {
            if(CollectionUtils.isEmpty(roleMission.getChapterRewardId())){
                List<Integer> rewardIds = new ArrayList<>();
                for(Integer idx : roleMission.getChapterReward()){
                    CFirstrewardChapter cModel = firstrewardChapterSysCache.getOrThrow(idx);
                    rewardIds.add(cModel.getChapter());
                }
                roleMission.setChapterRewardId(rewardIds);
                roleMissionDao.update(roleMission);
            }
        }

        List<Tower> towers = towerDao.listAll();
        for (Tower tower : towers) {
            if(CollectionUtils.isEmpty(tower.getStageRewardId())){
                List<Integer> rewardIds = new ArrayList<>();
                for(Integer idx : tower.getStageReward()){
                    CFirstRewardTower cModel = firstRewardTowerSysCache.getOrThrow(idx);
                    rewardIds.add(cModel.getChapter());
                }
                tower.setStageRewardId(rewardIds);
                towerDao.update(tower);
            }
        }
    }
}
