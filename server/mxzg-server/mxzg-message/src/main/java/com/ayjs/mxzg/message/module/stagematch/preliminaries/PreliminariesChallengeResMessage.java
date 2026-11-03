package com.ayjs.mxzg.message.module.stagematch.preliminaries;

import com.ayjs.mxzg.message.cross.RemoteServerMessage;
import com.ayjs.mxzg.message.module.stagematch.dto.RankDto;
import lombok.Getter;
import lombok.Setter;

import java.util.Collections;
import java.util.List;

/**
 * 挑战结果返回
 */
@Getter
@Setter
public class PreliminariesChallengeResMessage implements RemoteServerMessage {

    /***
     * 接收者
     */
    private long rid;

    private int serverId;

    /***
     * 攻击方新排名
     */
    private int attackRank;

    /***
     * 防守方新排名
     */
    private int defendRank;

    /***
     * 战报
     */
    private byte[] battleReport;

    /***
     * 是否交换排名
     */
    private boolean exchangeRank;
    /**
     * 新的列表
     */
    private List<RankDto> newAttackerLadder;
    /**
     * 语言id
     */
    private int languageId;

    @Override
    public int serverId() {
        return serverId;
    }

    public static PreliminariesChallengeResMessage valueOf(long rid, int serverId, int attackRank, int defendRank, byte[] battleReport, boolean exchangeRank, List<RankDto> newAttackerLadder){
        PreliminariesChallengeResMessage message = new PreliminariesChallengeResMessage();
        message.setRid(rid);
        message.setServerId(serverId);
        message.setAttackRank(attackRank);
        message.setDefendRank(defendRank);
        message.setBattleReport(battleReport);
        message.setExchangeRank(exchangeRank);
        message.setNewAttackerLadder(newAttackerLadder);
        return message;
    }

    public static PreliminariesChallengeResMessage createOf(int languageId){
        PreliminariesChallengeResMessage message = new PreliminariesChallengeResMessage();
        message.setLanguageId(languageId);
        return message;
    }

    /**
     * 获取新的天梯对手
     * @return
     */
    public List<RankDto> getNewAttackerLadder(){
        return this.newAttackerLadder == null ? Collections.emptyList() : this.newAttackerLadder;
    }

}
