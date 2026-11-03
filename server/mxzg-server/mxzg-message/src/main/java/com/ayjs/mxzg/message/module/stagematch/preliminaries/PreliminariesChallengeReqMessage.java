package com.ayjs.mxzg.message.module.stagematch.preliminaries;

import com.ayjs.mxzg.message.largecross.PlayerLargeCrossMessage;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

/**
 * 挑战请求
 *
 * @Author: CWJ
 * @Date: 2020/1/2
 **/
@Builder
@Getter
@Setter
public class PreliminariesChallengeReqMessage implements PlayerLargeCrossMessage {

    @Override
    public long getRid() {
        return attackRid;
    }

    /***
     * 攻击方信息
     */
    private long attackRid;
    private int attackServerId;
    /**
     * 战场Vo
     */
    private String attackBattlerVo;
    private int atkFighting;

    /***
     * 防守方信息
     */
    private long defendRid;
    private int defendRank;


}
