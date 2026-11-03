package com.ayjs.mxzg.message.module.rank.dto;

import com.ayjs.mxzg.common.top.ITop;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/7/1
 **/
@Getter
@Setter
public class Rank implements ITop<Long> {
    private long rankValue;
    private int rankTime;
    private long rankId;

    public Long getRankId() {
        return rankId;
    }

}