package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.mxzg.message.cross.RemoteServerMessage;
import lombok.Getter;
import lombok.Setter;

import java.util.Collections;
import java.util.List;

/**
 * 响应战斗结果
 */
@Getter
@Setter
public class ChallengeResMessage implements RemoteServerMessage {

    /**
     * 战报所属的玩家id
     */
    private long rid;
    /**
     * 战报所在的服务器id
     */
    private int serverId;

    /**
     * 段位id
     */
    private int stageId;

    /**
     * 精英积分
     */
    private int eliteIntegral;

    /**
     * 段位积分
     */
    private int integral;
    /**
     * 排名
     */
    private int rank;

    /** 结果 */
    private int resultType;

    /** 是否是晋级赛 */
    private boolean qualifyingMatch;

    /** 晋级赛结果 */
    private List<Integer> resultSet;

    /** 战报   */
    private byte[] battleReport;
    /**
     * 对手排名
     */
    private int opponentRank;

    public static ChallengeResMessage createOf(long rid, int serverId, int stageId, int eliteIntegral, int integral, int rank, int resultType, boolean qualifyingMatch, List<Integer> resultSet, byte[] battleReport, int opponentRank){
        ChallengeResMessage message = new ChallengeResMessage();
        message.setRid(rid);
        message.setServerId(serverId);
        message.setStageId(stageId);
        message.setEliteIntegral(eliteIntegral);
        message.setIntegral(integral);
        message.setRank(rank);
        message.setQualifyingMatch(qualifyingMatch);
        message.setBattleReport(battleReport);
        message.setResultType(resultType);
        message.setOpponentRank(opponentRank);
        if(resultSet == null){
            message.setResultSet(Collections.emptyList());
        } else {
            message.setResultSet(resultSet);
        }
        return message;
    }

    @Override
    public int serverId() {
        return serverId;
    }
}
