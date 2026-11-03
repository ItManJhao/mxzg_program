package com.ayjs.mxzg.largecross.module.stagematch.battle.stage;

import com.ayjs.mxzg.config.excel.constant.StageMatchConst;
import com.ayjs.mxzg.config.excel.entity.CSuperStageCycle;
import com.ayjs.mxzg.config.struct.StageType;
import com.ayjs.mxzg.largecross.module.stagematch.battle.dao.CrossStageMatchDao;
import com.ayjs.mxzg.largecross.module.stagematch.battle.dao.OpponentDao;
import com.ayjs.mxzg.largecross.module.stagematch.battle.dao.SeasonLegendDao;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.CrossStageMatch;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.Opponent;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.SeasonLegend;
import com.ayjs.mxzg.largecross.module.stagematch.battle.manager.OpponentGroupHolder;
import com.ayjs.mxzg.largecross.module.stagematch.battle.manager.StageMatchManager;
import com.ayjs.mxzg.largecross.servergroup.MessageHelper;
import com.ayjs.mxzg.message.module.stagematch.RankSettlementMessage;
import com.ayjs.mxzg.message.module.stagematch.SeasonSettlementMessage;
import com.ayjs.mxzg.message.module.stagematch.dto.LegendInfo;
import com.ayjs.mxzg.message.module.stagematch.dto.RankDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Slf4j
@Component
public class SettlementStageHandler implements StageHandler {


    @Autowired
    private SeasonLegendDao seasonLegendDao;
    @Autowired
    private MessageHelper messageHelper;
    @Autowired
    private OpponentDao opponentDao;
    @Autowired
    private CrossStageMatchDao crossStageMatchDao;
    @Autowired
    private StageMatchManager stageMatchManager;
    @Autowired
    private OpponentGroupHolder opponentGroupHolder;

    @Override
    public StageType getType() {
        return StageType.SETTLEMENT;
    }

    @Override
    public void handle(CSuperStageCycle cycle) {
        CrossStageMatch crossStageMatch = crossStageMatchDao.get();
        log.info("开始结算赛季信息");
        if(crossStageMatch.getStageType() != StageType.FINISH.ordinal()){
            log.info("当前赛季未结束，结算失败stage:{}", crossStageMatch.getStageType());
            return;
        }

        Collection<Integer> groupIds = opponentGroupHolder.getGroupIds();
        for (Integer groupId : groupIds) {
            settlementGroup(crossStageMatch.getSeason(), groupId);
        }
    }

    /**
     * 结算分组
     * @param season
     * @param groupId
     */
    private void settlementGroup(int season, int groupId){
        log.info("开始结算分组[{}]赛季[{}]", groupId, season);
        List<RankDto> ranks = stageMatchManager.getRankTop(groupId, StageMatchConst.SUPER_STAGE_NUMBER_RANKINGS);
        for(RankDto rankDto : ranks){
            Opponent opponent = opponentDao.get(rankDto.getRid());
            messageHelper.pushToMessage(RankSettlementMessage.createOf(rankDto.getRid(), opponent.getServerId(), rankDto.getRank()));
        }
        SeasonSettlementMessage message = SeasonSettlementMessage.createOf(season);
        messageHelper.pushToGroupMessage(groupId, message);
        log.info("通知赛区[{}]服务器结算赛季奖励", groupId);

        List<RankDto> seasonLegendRanks = stageMatchManager.getRankTop(groupId, StageMatchConst.SEASON_LEGEND_NUMBER_RANKINGS);
        List<LegendInfo> legendInfos = new ArrayList<>();
        for(RankDto rankDto : seasonLegendRanks){
            Opponent opponent = opponentDao.get(rankDto.getRid());
            if(opponent != null){
                LegendInfo legendInfo = LegendInfo.createOf(opponent.getServerId(), opponent.getName(), opponent.getStageId(), opponent.getRank(), opponent.getFighting(), opponent.getImage_id());
                legendInfos.add(legendInfo);
            }
        }

        SeasonLegend seasonLegend = new SeasonLegend();
        seasonLegend.setGroupId(groupId);
        seasonLegend.setSeason(season);
        seasonLegend.setLegendInfo(legendInfos);
        seasonLegendDao.add(seasonLegend);
        log.info("插入分组[{}]赛季传奇数据成功", groupId);
    }

}
