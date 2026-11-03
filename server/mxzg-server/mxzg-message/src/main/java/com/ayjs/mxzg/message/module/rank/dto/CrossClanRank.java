package com.ayjs.mxzg.message.module.rank.dto;

import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2019/12/19
 **/
@Setter
@Getter
public class CrossClanRank {

    private int rank;        //公会排名
    private long clanId;    //公会ID
    private int clanLevel; //公会等级
    private int clanPhoto;    //公会头像
    private String clanName; //公会名字
    private String headName; //公长名字
    private long damage;        //战斗力
    private int borderId;    //头像框
    private long score;        //分数
    private int serverId; //大区（服务器区号）.
    private int rankTime;
}
