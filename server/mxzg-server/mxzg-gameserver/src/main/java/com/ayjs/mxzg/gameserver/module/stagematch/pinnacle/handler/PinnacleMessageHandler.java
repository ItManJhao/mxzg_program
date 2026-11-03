package com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.handler;

import com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.dao.PinnacleReportDao;
import com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.domain.PinnacleReport;
import com.ayjs.mxzg.message.module.stagematch.StageMatchReqMessage;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.PinnacleOpenMessage;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 巅峰赛
 */
@Slf4j
@Component
public class PinnacleMessageHandler implements MessageHandler {


    @Autowired
    private PinnacleReportDao pinnacleReportDao;
    @Autowired
    private MessageDispatcher messageDispatcher;

    @RemoteMethod
    public void handlePreliminariesOpenMessage(PinnacleOpenMessage message){
        log.info("巅峰赛决赛开启，重置决赛数据");
        PinnacleReport report = pinnacleReportDao.getReport();
        report.reset();
        pinnacleReportDao.update(report);

        log.info("重新请求段位赛");
        messageDispatcher.dispatch(StageMatchReqMessage.getInstance());
    }

}
