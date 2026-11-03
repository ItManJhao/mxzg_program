package com.ayjs.mxzg.cross.module.crusadegroup.group.manager.stage;

import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupCycle;
import com.ayjs.mxzg.config.struct.CrusadeGroupStage;
import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.message.module.crusadegroup.group.EndBattleMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class EndBattleHandler implements CrusadeStageHandler {

    @Autowired
    private MessageHelper messageHelper;

    @Override
    public CrusadeGroupStage getStage() {
        return CrusadeGroupStage.END_BATTLE;
    }

    @Override
    public void handle(CCrusadeGroupCycle startCycle) {
        log.info("讨伐团战斗结束");
        messageHelper.pushToAll(EndBattleMessage.getInstance());
    }
}
