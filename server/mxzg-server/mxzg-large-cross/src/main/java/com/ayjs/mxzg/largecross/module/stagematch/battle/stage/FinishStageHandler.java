package com.ayjs.mxzg.largecross.module.stagematch.battle.stage;

import com.ayjs.mxzg.config.excel.entity.CSuperStageCycle;
import com.ayjs.mxzg.config.struct.StageType;
import com.ayjs.mxzg.largecross.module.stagematch.battle.dao.CrossStageMatchDao;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.CrossStageMatch;
import com.ayjs.mxzg.largecross.servergroup.MessageHelper;
import com.ayjs.mxzg.message.module.stagematch.StageMathFinishMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class FinishStageHandler implements StageHandler {


    @Autowired
    private MessageHelper messageHelper;
    @Autowired
    private CrossStageMatchDao crossStageMatchDao;

    @Override
    public StageType getType() {
        return StageType.FINISH;
    }

    @Override
    public void handle(CSuperStageCycle cycle) {
        log.info("段位赛结束，停止匹配");
        CrossStageMatch crossStageMatch = crossStageMatchDao.get();

        StageMathFinishMessage message = StageMathFinishMessage.valueOf(crossStageMatch.getSerialNumber());
        messageHelper.pushToAll(message);
    }
}
