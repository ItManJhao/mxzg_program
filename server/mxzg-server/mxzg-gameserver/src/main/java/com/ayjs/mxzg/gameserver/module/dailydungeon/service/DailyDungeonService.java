package com.ayjs.mxzg.gameserver.module.dailydungeon.service;

import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.gameserver.module.dailydungeon.constant.DailyDungeonModel;
import com.ayjs.mxzg.gameserver.module.dailydungeon.dao.DailyDungeonDao;
import com.ayjs.mxzg.gameserver.module.dailydungeon.domain.DailyDungeon;
import com.ayjs.mxzg.protocol.DailyDungeonGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class DailyDungeonService {

    @Autowired
    private DailyDungeonDao dailyDungeonDao;

    /**
     * 查询玩家副本
     *
     * @param rid
     * @return
     */
    public DailyDungeon select(long rid) {
        DailyDungeon dailyDungeon = dailyDungeonDao.get(rid);
        if (dailyDungeon == null) {
            dailyDungeon = new DailyDungeon();
            dailyDungeon.setRid(rid);
            dailyDungeon.setDungeonMap(new HashMap<>());
            dailyDungeonDao.add(dailyDungeon);
        } else {
            Map<Integer, DailyDungeonModel> dungeonMap = dailyDungeon.getDungeonMap();
            dungeonMap.forEach((k, v) -> {
                if (v.getRefreshTime() < DateTimeUtil.currentSecond()) {
                    v.setBattleNum(0);
                    v.setRefreshTime(DateTimeUtil.tomorrowBreak());
                }
            });
            dailyDungeon.setDungeonMap(dungeonMap);
            dailyDungeonDao.update(dailyDungeon);
        }
        return dailyDungeon;
    }


    /**
     * 更新
     *
     * @param dailyDungeon
     */
    public void updateOne(DailyDungeon dailyDungeon) {
        dailyDungeonDao.update(dailyDungeon);
    }

    public DailyDungeonGMsg.GReqDailyDungeonData toGReqDailyDungeonData(int dungeonType, DailyDungeonModel dailyDungeonModel) {
        DailyDungeonGMsg.GReqDailyDungeonData.Builder builder = DailyDungeonGMsg.GReqDailyDungeonData.newBuilder();
        builder.setMissionType(dungeonType);
        builder.setCount(dailyDungeonModel.getBattleNum());
        builder.setMission(dailyDungeonModel.getPassMaxMission());
        return builder.build();
    }
}
