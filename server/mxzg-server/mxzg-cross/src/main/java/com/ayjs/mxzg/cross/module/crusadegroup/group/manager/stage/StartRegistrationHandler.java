package com.ayjs.mxzg.cross.module.crusadegroup.group.manager.stage;

import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupCycle;
import com.ayjs.mxzg.config.struct.CrusadeGroupStage;
import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.cross.module.crusadegroup.group.dao.CrossCrusadeGroupDao;
import com.ayjs.mxzg.cross.module.crusadegroup.group.dao.CrusadeGroupRegistrationDao;
import com.ayjs.mxzg.cross.module.crusadegroup.map.dao.CrossCrusadersDao;
import com.ayjs.mxzg.cross.module.rank.service.RankHelper;
import com.ayjs.mxzg.message.module.crusadegroup.group.StartRegistrationMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;



/**
 * 开启报名
 */
@Slf4j
@Component
public class StartRegistrationHandler implements CrusadeStageHandler {

    @Autowired
    private MessageHelper messageHelper;
    @Autowired
    private CrusadeGroupRegistrationDao crusadeGroupRegistrationDao;
    @Autowired
    private CrossCrusadeGroupDao crossCrusadeGroupDao;
    @Autowired
    private CrossCrusadersDao crossCrusadersDao;

    @Autowired
    private RankHelper rankHelper;

    @Override
    public CrusadeGroupStage getStage() {
        return CrusadeGroupStage.START_REGISTRATION;
    }

    @Override
    public void handle(CCrusadeGroupCycle startCycle) {
        log.info("讨伐团开始开启报名");
        crusadeGroupRegistrationDao.truncateAll();
        crossCrusadeGroupDao.truncateAll();
        crossCrusadersDao.truncateAll();
        rankHelper.clearCruGroupRankData();//讨伐团排行榜数据清理

        messageHelper.pushToAll(StartRegistrationMessage.getInstance());
    }

}
