package com.ayjs.mxzg.largecross.module.stagematch.preliminaries.converter;

import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.Opponent;
import com.ayjs.mxzg.message.module.stagematch.dto.OpponentDto;
import com.ayjs.mxzg.message.module.stagematch.dto.RankDto;
import com.ayjs.mxzg.message.module.stagematch.preliminaries.PreliminariesChallengeResMessage;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleReport;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import java.util.List;

/**
 * 段位赛转换器
 */
@Component
public class PreliminariesConverter {

    /**
     * 转换dto
     * @param opponent
     * @return
     */
    public OpponentDto convertFrom(Opponent opponent){
        OpponentDto opponentDto = new OpponentDto();
        opponentDto.setRid(opponent.getRid());
        opponentDto.setIntegral(opponent.getIntegral());
        opponentDto.setEliteIntegral(opponent.getEliteIntegral());
        opponentDto.setLastStageId(opponent.getStageId());
        opponentDto.setName(opponent.getName());
        opponentDto.setBattlerVo(opponent.getBattlerVo());
        opponentDto.setRank(opponent.getRank());
        opponentDto.setServerId(opponent.getServerId());
        opponentDto.setStageId(opponent.getStageId());
        opponentDto.setImage_id(opponent.getImage_id());
        opponentDto.setFighting(opponent.getFighting());
        return opponentDto;
    }

    /**
     * 构建挑战结果
     * @param report
     * @param opponent
     * @param attackNewRank
     * @param defendNewRank
     * @param newAttackerLadder
     * @return
     */
    public PreliminariesChallengeResMessage buildPreliminariesChallengeResMessage(BattleReport report, Opponent opponent, int attackNewRank, int defendNewRank,
                                                                                  List<RankDto> newAttackerLadder, boolean exchangeRank){
        PreliminariesChallengeResMessage attackerResMessage = new PreliminariesChallengeResMessage();
        attackerResMessage.setBattleReport(report.toByteArray());
        attackerResMessage.setRid(opponent.getRid());
        attackerResMessage.setServerId(opponent.getServerId());
        attackerResMessage.setAttackRank(attackNewRank);
        attackerResMessage.setDefendRank(defendNewRank);// 给默认值
        attackerResMessage.setExchangeRank(exchangeRank);
        if(!CollectionUtils.isEmpty(newAttackerLadder)){
            attackerResMessage.setNewAttackerLadder(newAttackerLadder);
        }
        return attackerResMessage;
    }

}
