package com.ayjs.mxzg.message.module.rank.dto;

import lombok.Getter;
import lombok.Setter;

/**
 * 讨伐团成员boss伤害排行
 */
@Getter
@Setter
public class CrossCruGroupHurtP {
    private long rankId;//排名id
    private String roleName;
    private int borderId;//头像框ID
    private int headId;//头像ID
    private int rank;//排名
    private long cruGroupId;//讨伐团id
    private long bossHurt;//boss伤害
    private int rankTime;
    private int serverId;
}
