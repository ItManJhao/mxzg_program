package com.ayjs.mxzg.gameserver.module.rank.domain;

import com.ayjs.mxzg.common.top.ITop;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2019/10/16
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
