package com.ayjs.mxzg.message.module.rank.dto;

import lombok.Getter;
import lombok.Setter;

/**
 * 讨伐团成员自然之力排行
 */
@Getter
@Setter
public class CrossCruGroupItemP {
    private long rankId;//排名id
    private String roleName;
    private int borderId;//头像框ID
    private int headId;//头像ID
    private int rank;//排名
    private long cruGroupId;//讨伐团id
    private long shenBinJh;//神兵精华数量
    private int rankTime;
    private int serverId;
}
