package com.ayjs.mxzg.gameserver.log.dungeon.observer;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.log.dungeon.domain.DungeonHeroLineLog;
import com.ayjs.mxzg.gameserver.log.dungeon.domain.DungeonLog;
import com.ayjs.mxzg.gameserver.log.dungeon.domain.DungeonShopLog;
import com.ayjs.mxzg.gameserver.module.dungeon.domain.DungeonInfo;
import com.ayjs.mxzg.gameserver.module.dungeon.event.DungeonBattleEndEvent;
import com.ayjs.mxzg.gameserver.module.dungeon.event.DungeonHeroLineEvent;
import com.ayjs.mxzg.gameserver.module.dungeon.event.DungeonShopEvent;
import com.ayjs.mxzg.gameserver.module.dungeon.service.DungeonInfoService;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * 庇护所日志
 *
 * @author hyx
 */
@Observer
public class DungeonLogObserver {

    @Autowired
    private LogService logService;
    @Autowired
    private LogEntityFactory logEntityFactory;
    @Autowired
    private DungeonInfoService dungeonInfoService;

    /**
     * 保存队伍日志
     */
    @Subscribe
    private void listen(DungeonHeroLineEvent event) {
        DungeonHeroLineLog dungeonLog = logEntityFactory.create(DungeonHeroLineLog.class);
        dungeonLog.setRid(event.getRid());
        dungeonLog.setTime(DateTimeUtil.currentSecond());
        DungeonInfo dungeonInfo = dungeonInfoService.select(event.getRid());
        dungeonInfo.getBattleMap().forEach((k, v) -> {
            dungeonLog.getMapIds().put(k,v.getHeros().get(0).getId());
            dungeonLog.getMapTypes().put(k,v.getHeros().get(0).getHeroId());
        });
        logService.addLog(dungeonLog);
    }


    @Subscribe
    private void listen(DungeonBattleEndEvent event) {
        DungeonInfo dungeonInfo = dungeonInfoService.select(event.getRid());
        DungeonLog dungeonLog = logEntityFactory.create(DungeonLog.class);
        dungeonLog.setRid(event.getRid());
        dungeonLog.setBattle_time(DateTimeUtil.currentSecond());
        dungeonLog.setIsWin(event.isWin() ? 1 : 0);
        dungeonLog.setStage(dungeonInfo.getNowStage());
        dungeonLog.setMonsterLevel(event.getMonsterLevel());
        logService.addLog(dungeonLog);
    }

    @Subscribe
    private void listen(DungeonShopEvent event){
        DungeonShopLog log = logEntityFactory.create(DungeonShopLog.class);
        log.setRid(event.getRid());
        log.setShopIdx(event.getIdx());
        if (CollectionUtil.isNotEmpty(event.getItem_cost())) {
            ImmutableThing immutableThing = event.getItem_cost().get(0);
            log.setCostItemType(immutableThing.getItem_type());
            log.setCostItemNum(immutableThing.getItem_num());
        }
        if (CollectionUtil.isNotEmpty(event.getItem_add())) {
            ImmutableThing immutableThing = event.getItem_add().get(0);
            log.setRewardItemType(immutableThing.getItem_type());
            log.setRewardItemNum(immutableThing.getItem_num());
        }
        log.setDateTime(DateTimeUtil.currentSecond());
        logService.addLog(log);
    }
}
