package com.ayjs.mxzg.message.module.rank.dto;

import lombok.Getter;
import lombok.Setter;

/**
 * 讨伐团神兵精华排行
 */
@Getter
@Setter
public class CrossCruGroupItem {
    private long rankId;//排名id  讨伐团id
    private int rank;//排名
    private String groupName;//讨伐团名字
    private int emblem;//团徽
    private long shenBinJh;//神兵精华数量
    private int rankTime;
}
