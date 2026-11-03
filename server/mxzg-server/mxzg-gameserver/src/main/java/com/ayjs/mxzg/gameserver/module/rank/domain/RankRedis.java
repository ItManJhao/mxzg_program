package com.ayjs.mxzg.gameserver.module.rank.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;

/**
 * @Author: CWJ
 * @Date: 2019/12/18
 **/
public class RankRedis {
    @Id
    @Column(name = "rank_id", comment = "唯一标识")
    private long rankId;
    @Column(name = "rank_value", comment = "排行榜值")
    private long rankValue;
    @Column(name = "rank_time", comment = "上榜时间")
    private int rankTime;

    public Long getRankId() {
        return rankId;
    }
}
