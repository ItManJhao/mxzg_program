package com.ayjs.mxzg.message.module.ladder.message;

import com.ayjs.mxzg.message.cross.RemoteServerMessage;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

/**
 * 挑战结果返回
 *
 * @Author: CWJ
 * @Date: 2020/1/2
 **/
@Getter
@Setter
public class LadderChallengeResMessage implements RemoteServerMessage {

    /***
     * 接收者
     */
    private long rid;

    private int serverId;
//
//    private int attackServerId;
//
//    /***
//     * 防守方
//     */
//    private long defendRid;
//
//    private int defendServerId;
//
//    /***
//     * 胜利方
//     */
//    private long winRid;

    /***
     * 攻击方新排名
     */
    private int attackRank;

    /***
     * 防守方新排名
     */
    private int defendRank;

    /***
     * 防守方是否是机器人
     */
    private boolean defendReallyPlayer;

    /***
     * 攻击方新的防守方（胜利之后可能要更换列表）
     */
    private List<LadderDefenderData> attackNewDefends;

    /***
     * 防守方新的防守方列表
     */
    private List<LadderDefenderData> defendNewDefends;

//    /***
//     * 战报id
//     */
//    private long battleId;

    /***
     * 操作码，读ErrorCode
     */
    private int operatorCode;

    /***
     * 战报
     */
    private byte[] battleReport;

    /***
     * 是否是大神战斗
     */
    private boolean superiorBattle;

    /***
     * 是否交换排名
     */
    private boolean exchangeRank;

    @Override
    public int serverId() {
        return serverId;
    }
}
