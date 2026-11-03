package com.ayjs.mxzg.gameserver.module.stagematch.battle.domain;

import com.ayjs.mxzg.config.excel.constant.StageMatchConst;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleLog;
import lombok.Getter;
import lombok.Setter;

/**
 * 匹配信息
 */
@Getter
@Setter
public class MatchLog {

    private byte[] log;    //日志
    private int battleTime; //时间戳
    private boolean win;    //是否胜利
    private Opponent attacker;  //攻方
    private Opponent defender;  //守方

    /**
     * 是否是大神
     * @return
     */
    public boolean isGreatGod(){
        return attacker.getStageId() >= StageMatchConst.GREAT_STYLE_STAGE_ID;
    }

    /**
     * 解析日志
     * @return
     */
    public BattleLog parseLog(){
        try{
            return BattleLog.parseFrom(log);
        } catch (Exception ex){
            ex.printStackTrace();
        }
        return null;
    }
}
