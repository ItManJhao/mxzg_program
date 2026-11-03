package com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.domain;

import lombok.Getter;
import lombok.Setter;

/**
 * 我的战斗记录
 */
@Getter
@Setter
public class MyRecord {

    private int rank;           //自己改变后的名次名次
    private int oldRank;        //之前的久排名
    private String name;        //名称
    private int serverId;       //服务器
    private String battleId;    //战场id
    private int battleTime;     //时间戳
    private int headId;         //头像id
    private int borderId;       //头像框id
    private int imageId;        //形象id
    private boolean win;        //是否胜利
    private int fighting;       //战力
    private boolean attacker;   //是否是攻方
    private int level;          //等级
}
