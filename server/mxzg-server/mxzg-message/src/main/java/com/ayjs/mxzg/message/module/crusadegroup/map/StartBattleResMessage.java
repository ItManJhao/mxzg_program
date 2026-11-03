package com.ayjs.mxzg.message.module.crusadegroup.map;

import com.ayjs.mxzg.message.largecross.CrusadeGroupMessage;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

/**
 * 攻击领地返回
 */
@Getter
@Setter
@Builder
public class StartBattleResMessage implements CrusadeGroupMessage {


    private int territoryId;    //领地id
    private int formationId;     //攻击的npc阵容id
    private boolean occupied;      // 是否占领了领地
    private byte[] battleReport;    //战报
    private int element;      // 元素
    private int num;    //当前第几波
    private int totalNum;   //总波数
    private long occupied_id;   //占领者的id
    private int refreshCountdown;   //刷新时间戳
    private int guardTime;  //保护时间
    private int languageId; //语言表id ，该字段不为0时说明战斗挑战条件不满足
    private long bossTotalDamage;   //对boss造成的总伤害
    private long bossDamage;    //当次boss伤害
    public static StartBattleResMessage createOf(int languageId) {
        StartBattleResMessageBuilder builder = StartBattleResMessage.builder();
        return builder.languageId(languageId).build();
    }

}
