package com.ayjs.mxzg.largecross.module.stagematch.battle.handler;

import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.SuperStageCycleSysCache;
import com.ayjs.mxzg.config.excel.cache.SuperStageSysCache;
import com.ayjs.mxzg.config.excel.constant.StageMatchConst;
import com.ayjs.mxzg.config.excel.entity.CSuperStage;
import com.ayjs.mxzg.config.excel.entity.CSuperStageCycle;
import com.ayjs.mxzg.largecross.module.stagematch.battle.converter.StageMatchConverter;
import com.ayjs.mxzg.largecross.module.stagematch.battle.dao.CrossStageMatchDao;
import com.ayjs.mxzg.largecross.module.stagematch.battle.dao.OpponentDao;
import com.ayjs.mxzg.largecross.module.stagematch.battle.dao.SeasonLegendDao;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.CrossStageMatch;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.Opponent;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.SeasonLegend;
import com.ayjs.mxzg.largecross.module.stagematch.battle.manager.OpponentGroup;
import com.ayjs.mxzg.largecross.module.stagematch.battle.manager.OpponentGroupHolder;
import com.ayjs.mxzg.largecross.module.stagematch.battle.manager.StageMatchManager;
import com.ayjs.mxzg.largecross.module.stagematch.battle.manager.StageMatchWorker;
import com.ayjs.mxzg.largecross.servergroup.MessageHelper;
import com.ayjs.mxzg.largecross.servergroup.SessionManager;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.largecross.LargeServerConnectedMessage;
import com.ayjs.mxzg.message.module.stagematch.*;
import com.ayjs.mxzg.message.module.stagematch.dto.OpponentDto;
import com.ayjs.mxzg.message.module.stagematch.dto.RankDto;
import com.ayjs.mxzg.message.module.stagematch.gm.CleanOpponentMessage;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

/**
 * 段位赛
 */
@Slf4j
@Component
public class StageMatchHandler implements MessageHandler {

    @Autowired
    private SeasonLegendDao seasonLegendDao;
    @Autowired
    private OpponentDao opponentDao;
    @Autowired
    private CrossStageMatchDao crossStageMatchDao;
    @Autowired
    private SuperStageSysCache superStageSysCache;
    @Autowired
    private SuperStageCycleSysCache superStageCycleSysCache;
    @Autowired
    private OpponentGroupHolder opponentGroupHolder;
    @Autowired
    private StageMatchManager stageMatchManager;
    @Autowired
    private StageMatchConverter stageMatchConverter;
    @Autowired
    private StageMatchWorker stageMatchWorker;
    @Autowired
    private SessionManager sessionManager;
    @Autowired
    private MessageHelper messageHelper;


    /**
     * 请求赛季信息
     * @param message
     */
    @RemoteMethod
    public void handleStageMatchResMessage(StageMatchReqMessage message, Connection connection){
        Integer serverId = sessionManager.getServerIdBy(connection.getClientId());
        log.info("服务器[{}]请求赛季信息!!!", serverId);
        CrossStageMatch crossStageMatch = crossStageMatchDao.get();
        StageMatchResMessage rspMessage;
        if(crossStageMatch.getSeason() != 0){
            rspMessage = StageMatchResMessage.valueOf(crossStageMatch.getSerialNumber(), crossStageMatch.getSeason(), crossStageMatch.getStageType(), crossStageMatch.getStartTime(), crossStageMatch.getEndTime());
        } else {
            rspMessage = StageMatchResMessage.getInstance();
        }
        connection.send(rspMessage);
    }

    /**
     * 报告角色信息
     * @param message
     */
    @RemoteMethod
    public void handleReportOpponentMessage(ReportOpponentMessage message){
        log.debug("收到玩家rid:{}角色数据", message.getRid());
        Opponent opponent = opponentDao.getOrCreate(message.getRid());
        opponent.updateInfo(message.getServerId(), message.getName(), message.getBattlerVo(), message.getFighting(), message.getImageId(), message.getLevel());
        opponentDao.update(opponent);
        opponentGroupHolder.addOpponent(opponent);
    }

    /**
     * 请求匹配
     * @param message
     */
    @RemoteMethod
    public MatchingResMessage handleRequestMatchingMessage(MatchingReqMessage message){
        Opponent challenger = opponentDao.get(message.getRid());
        if(challenger == null){
            log.error("请求匹配失败，没有找到匹配数据rid={}", message.getRid());
            return MatchingResMessage.createOf(message.getRid(), null, 0);
        }

        challenger.updateBattleInfo(message.getBattleVo(), message.getFighting(), message.getHeadId(), message.getBorderId());
        Opponent opponent = stageMatchManager.matching(challenger, message.isSkipArray(), TimeDateUtil.getCurrentTimeInt());
        opponentDao.update(challenger);
        if(opponent == null){
            return MatchingResMessage.createEmpty();
        }
        OpponentDto opponentDto = stageMatchConverter.convertFrom(opponent);
        return MatchingResMessage.createOf(challenger.getRid(), opponentDto, challenger.getBattleTime());
    }


    /**
     * 开始挑战
     * @param message
     */
    @RemoteMethod
    public void handleChallengeReqMessage(ChallengeReqMessage message){
        Opponent challenger = opponentDao.get(message.getRid());
        if(challenger == null){
            log.error("请求匹配失败，没有找到匹配数据rid={}", message.getRid());
            return;
        }
        challenger.updateBattleInfo(message.getBattlerVo(), message.getFighting());

        stageMatchManager.startBattle(challenger, message.getSerialNumber());
    }

    /**
     * 请求赛季传奇
    * @param message
     */
    @RemoteMethod
    public SeasonLegendResMessage handleSeasonLegendReqMessage(SeasonLegendReqMessage message, Connection connection){
        CrossGroup group = sessionManager.getGroupByClientId(connection.getClientId());
        if(group == null){
            return SeasonLegendResMessage.createOf(message.getSeason(), Collections.emptyList());
        }

        SeasonLegend seasonLegend = seasonLegendDao.get(group.getGroupId(), message.getSeason());
        if(seasonLegend == null || CollectionUtils.isEmpty(seasonLegend.getLegendInfo())){
            return SeasonLegendResMessage.createOf(message.getSeason(), Collections.emptyList());
        }
        return SeasonLegendResMessage.createOf(message.getSeason(), seasonLegend.getLegendInfo());
    }

    /**
     * 请求排行榜
     * @param message
     * @return
     */
    @RemoteMethod
    public RanksResMessage handleRanksReqMessage(RanksReqMessage message, Connection connection){
        CrossGroup group = sessionManager.getGroupByClientId(connection.getClientId());
        if(group == null){
            return RanksResMessage.of(Collections.emptyList());
        }
        OpponentGroup opponentGroup = opponentGroupHolder.getGroup(group.getGroupId());
        List<RankDto> ranks = opponentGroup.getRankTop(StageMatchConst.RANKING_OF_NUMBER);
        return RanksResMessage.of(ranks);
    }


    /**
     * gm操作进入下一阶段
     * @param message
     * @return
     */
    @RemoteMethod
    public void handleNextStageMessage(NextStageMessage message){
        CrossStageMatch crossStageMatch = crossStageMatchDao.get();
        CSuperStageCycle nexStage = superStageCycleSysCache.getById(crossStageMatch.getCycleId() + 1);
        if(nexStage == null){
            log.error("找不到下一个赛季信息，进入下一个阶段失败");
            return;
        }
        stageMatchWorker.executeCycle(nexStage);

        crossStageMatch.setStartTime(LocalDateTime.now());
        crossStageMatch.setEndTime(LocalDateTime.now().plusDays(1));
        crossStageMatchDao.update(crossStageMatch);
        for (Integer groupId : opponentGroupHolder.getGroupIds()) {
            if(crossStageMatch.getSeason() != 0){
                LargeServerConnectedMessage msg = LargeServerConnectedMessage.getInstance();
                messageHelper.pushToGroupMessage(groupId, msg);
            }
        }
    }

    /**
     * 清理列表
     * @param message
     * @return
     */
    @RemoteMethod
    public void handleCleanOpponentMessage(CleanOpponentMessage message){
        opponentGroupHolder.reset();
        opponentDao.truncateAll();
    }

    /**
     * 设置段位
     * @param message
     * @return
     */
    @RemoteMethod
    public void handleSetStageMessage(SetStageMessage message){
        Opponent opponent = opponentDao.get(message.getRid());
        CSuperStage superStage = superStageSysCache.getOrThrow(message.getStageId());
        opponent.upgradeStage(superStage);
        opponentDao.update(opponent);
        opponentGroupHolder.updateOpponent(opponent, true);
    }

}
