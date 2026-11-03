package com.ayjs.mxzg.cross.module.crusadegroup.group.manager.stage;

import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupCycle;
import com.ayjs.mxzg.config.struct.CrusadeGroupStage;
import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.cross.module.crusadegroup.group.dao.CrusadeSystemDao;
import com.ayjs.mxzg.cross.module.crusadegroup.group.domain.CrusadeSystem;
import com.ayjs.mxzg.cross.module.crusadegroup.group.manager.CrusadeWorker;
import com.ayjs.mxzg.message.module.crusadegroup.group.CloseMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class CloseHandler implements CrusadeStageHandler {

    @Autowired
    private CrusadeWorker crusadeWorker;
    @Autowired
    private MessageHelper messageHelper;
    @Autowired
    private CrusadeSystemDao crusadeSystemDao;

    @Override
    public CrusadeGroupStage getStage() {
        return CrusadeGroupStage.CLOSE;
    }

    @Override
    public void handle(CCrusadeGroupCycle startCycle) {
        log.info("讨伐团活动关闭");

        CrusadeSystem crusadeSystem = crusadeSystemDao.get();
        crusadeWorker.init(startCycle.getRound() + 1, crusadeSystem);
        crusadeSystemDao.update(crusadeSystem);

        messageHelper.pushToAll(CloseMessage.getInstance());
    }
}
