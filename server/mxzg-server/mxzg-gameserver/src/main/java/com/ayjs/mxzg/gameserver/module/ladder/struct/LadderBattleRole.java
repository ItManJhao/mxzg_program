package com.ayjs.mxzg.gameserver.module.ladder.struct;

import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/1/2
 **/
@Getter
@Setter
public class LadderBattleRole {

    private long rid;         //玩家id
    private String nick;      //玩家名字
    private int imageId;      //玩家形象
    private int borderId;     //头像框
    private int headId;       //头像id
    private int ladderRank;   //天梯排名
    private int serverId;     //服务器
    private long fight;       //战力
    private int level;

}
