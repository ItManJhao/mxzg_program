package com.ayjs.mxzg.gameserver.module.stagematch.battle.domain;

import lombok.Getter;
import lombok.Setter;

/**
 * 对手信息
 */
@Getter
@Setter
public class Opponent {
    private int serverId;
    private String name;    // 名字
    private int stageId;    // 段位
    private int rank;    // 排名
    private int level;      // 等级
    private int headId;    //头像
    private int borderId;   //头像框
    private int fighting;   // 战力
}
