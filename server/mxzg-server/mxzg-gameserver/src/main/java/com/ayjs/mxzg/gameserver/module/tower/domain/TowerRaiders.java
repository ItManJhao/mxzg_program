package com.ayjs.mxzg.gameserver.module.tower.domain;

import com.ayjs.mxzg.protocol.BattleGMsg;
import lombok.Getter;
import lombok.Setter;

/**
 * 爬塔攻略
 */
@Getter
@Setter
public class TowerRaiders {

    /** 战场id */
    private String battleId;

    /** 昵称 */
    private String nickName;

    /** 时长 */
    private int duration;

    /** 战力 */
    private int ability;

    /** 头像*/
    private int headId;

    /** 头像框 */
    private int borderId;

    public static TowerRaiders createOf(BattleGMsg.BattleLog battleLog, int ability, int headId, int borderId){
        TowerRaiders raiders = new TowerRaiders();
        raiders.setBattleId(battleLog.getBattleId());
        raiders.setAbility(ability);
        raiders.setDuration(battleLog.getBattleDuration());
        raiders.setNickName(battleLog.getAttackerLog().getName());
        raiders.setHeadId(headId);
        raiders.setBorderId(borderId);
        return raiders;
    }
}
