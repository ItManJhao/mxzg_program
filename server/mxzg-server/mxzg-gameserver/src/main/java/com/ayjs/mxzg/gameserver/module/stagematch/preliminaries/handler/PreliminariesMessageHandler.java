package com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.handler;

import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.config.struct.TitleType;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.converter.StageMatchConverter;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.dao.PreliminariesLadderDao;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.dao.PreliminariesGreatStyleLogDao;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.dao.PreliminariesRecordDao;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.domain.BattleRecord;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.domain.MyRecord;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.domain.PreliminariesGreatStyleLog;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.domain.PreliminariesLadder;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.domain.PreliminariesRecord;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.service.PreliminariesRankService;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.service.PreliminariesService;
import com.ayjs.mxzg.gameserver.module.title.event.RecoverTitleEvent;
import com.ayjs.mxzg.message.module.stagematch.StageMatchReqMessage;
import com.ayjs.mxzg.message.module.stagematch.dto.RankDto;
import com.ayjs.mxzg.message.module.stagematch.preliminaries.LeaderBoardReqMessage;
import com.ayjs.mxzg.message.module.stagematch.preliminaries.LeaderBoardResMessage;
import com.ayjs.mxzg.message.module.stagematch.preliminaries.PreliminariesChallengeResMessage;
import com.ayjs.mxzg.message.module.stagematch.preliminaries.PreliminariesGetLineUpReqMessage;
import com.ayjs.mxzg.message.module.stagematch.preliminaries.PreliminariesGetLineUpResMessage;
import com.ayjs.mxzg.message.module.stagematch.preliminaries.PreliminariesOpenMessage;
import com.ayjs.mxzg.message.module.stagematch.preliminaries.PreliminariesSuperiorBattleMessage;
import com.ayjs.mxzg.message.module.stagematch.preliminaries.PushRankExchangeMessage;
import com.ayjs.mxzg.module.battle.command.SaveBattleReportCommand;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleReport;
import com.ayjs.mxzg.protocol.PinnacleGMsg.GResPinnacleLineData;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.google.protobuf.InvalidProtocolBufferException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 巅峰赛
 */
@Slf4j
@Component
public class PreliminariesMessageHandler implements MessageHandler {

    @Autowired
    private EventBus eventBus;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private StageMatchConverter stageMatchConverter;
    @Autowired
    private PreliminariesService preliminariesService;
    @Autowired
    private PreliminariesRankService preliminariesRankService;
    @Autowired
    private PreliminariesLadderDao preliminariesLadderDao;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private PreliminariesRecordDao preliminariesRecordDao;
    @Autowired
    private PreliminariesGreatStyleLogDao preliminariesGreatStyleLogDao;

    @RemoteMethod
    public void handlePreliminariesOpenMessage(PreliminariesOpenMessage message){
        log.info("赛季预赛开启，重置所有预赛数据");
        List<PreliminariesLadder> ladders = preliminariesLadderDao.listAll();
        for (PreliminariesLadder ladder : ladders) {
            ladder.seasonReset();
            preliminariesLadderDao.update(ladder);

            PreliminariesRecord preliminariesRecord = preliminariesRecordDao.getOrCreate(ladder.getRid());
            preliminariesRecord.cleanRecords();
            preliminariesRecordDao.update(preliminariesRecord);
        }

        PreliminariesGreatStyleLog preliminariesGreatStyleLog = preliminariesGreatStyleLogDao.get();
        preliminariesGreatStyleLog.cleanRecords();
        preliminariesGreatStyleLogDao.update(preliminariesGreatStyleLog);

        eventBus.post(RecoverTitleEvent.valueOf(TitleType.PINNACLE));
        log.info("回收称号完毕");

        log.info("重新请求段位赛");
        messageDispatcher.dispatch(StageMatchReqMessage.getInstance());
        messageDispatcher.dispatch(LeaderBoardReqMessage.getInstance());
    }

    @RemoteMethod
    public void replaceRank(LeaderBoardResMessage message) {
        preliminariesRankService.replaceRank(message.getRanking());
    }

    @RemoteMethod
    public void handlePushRankExchangeMessage(PushRankExchangeMessage message){
        RankDto challengerDto = message.getChallenger();
        RankDto opponent = message.getOpponent();
        if(!preliminariesRankService.exchangeRanking(challengerDto, opponent)){
            messageDispatcher.dispatch(LeaderBoardReqMessage.getInstance());
        }
    }

    @RemoteMethod
    public void handlePreliminariesSuperiorBattleMessage(PreliminariesSuperiorBattleMessage message) {
        BattleGMsg.BattleReport battleReport = null;
        try {
            battleReport = BattleGMsg.BattleReport.parseFrom(message.getBattleReport());
        } catch (InvalidProtocolBufferException e) {
            log.error("战报解析错误", e);
            return;
        }

        BattleRecord battleRecord = stageMatchConverter.buildBattleRecord(message.getAttackRank(), message.getDefendRank(), battleReport.getLog());
        PreliminariesGreatStyleLog greatStyleLog = preliminariesGreatStyleLogDao.get();
        greatStyleLog.addLog(battleRecord);
        preliminariesGreatStyleLogDao.update(greatStyleLog);

        //保存战报
        SaveBattleReportCommand saveBattleReportCommand = SaveBattleReportCommand.of(battleReport);
        commandBus.invoke(saveBattleReportCommand);

    }

    @RemoteMethod
    public void handlePreliminariesChallengeResMessage(PreliminariesChallengeResMessage message){
        PreliminariesLadder preliminariesLadder = preliminariesService.getLadder(message.getRid());
        preliminariesLadder.updateDefends(message.getNewAttackerLadder());
        preliminariesLadderDao.update(preliminariesLadder);

        try {
            BattleReport report = BattleReport.parseFrom(message.getBattleReport());

            int oldRank = message.isExchangeRank() ? message.getAttackRank() : message.getDefendRank();
            MyRecord myRecord = stageMatchConverter.buildMyRecord(message.getDefendRank(), oldRank, report.getLog(), report.getLog().getAttackerLog(), message.getRid());
            PreliminariesRecord preliminariesRecord = preliminariesRecordDao.getOrCreate(message.getRid());
            preliminariesRecord.addLog(myRecord);
            preliminariesRecordDao.update(preliminariesRecord);

            commandBus.invoke(SaveBattleReportCommand.of(report));

        } catch (InvalidProtocolBufferException e) {
            e.printStackTrace();
        }
    }


    @RemoteMethod
    public PreliminariesGetLineUpResMessage handlePreliminariesGetLineUpReqMessage(PreliminariesGetLineUpReqMessage message){
        GResPinnacleLineData.Builder builder = preliminariesService.builderLineup(message.getRid());
        return PreliminariesGetLineUpResMessage.of(builder.build().toByteArray());
    }

}
