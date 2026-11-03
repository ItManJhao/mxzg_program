package com.ayjs.mxzg.message.module.floatingIslands.struct;

import com.ayjs.mxzg.common.top.ITop;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/7/1
 **/
@Getter
@Setter
public class RankData implements ITop<Long> {
    private long rankValue;
    private long fighting;
    private int rankTime;
    private long rankId;

    @Override
    public Long getRankId() {
        return rankId;
    }

}
