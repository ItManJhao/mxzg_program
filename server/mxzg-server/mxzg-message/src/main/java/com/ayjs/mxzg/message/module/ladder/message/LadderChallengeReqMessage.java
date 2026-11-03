package com.ayjs.mxzg.message.module.ladder.message;

import com.ayjs.mxzg.message.cross.CrossMessage;
import com.ayjs.mxzg.message.cross.PlayerCrossMessage;
import com.ayjs.mxzg.message.module.study.ResBattlerVOMessage;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

/**
 * 挑战请求
 *
 * @Author: CWJ
 * @Date: 2020/1/2
 **/
@Builder
@Getter
@Setter
public class LadderChallengeReqMessage implements PlayerCrossMessage {

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
    private byte[] attackBattlerVo;
    private int atkFighting;


    /***
     * 防守方信息
     */
    private long defendRid;
    private int defendServerId;
    private int defendRank;
    /**
     * 战场Vo
     */
    private byte[] defendBattlerVo;

}
