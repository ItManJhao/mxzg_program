package com.ayjs.mxzg.largecross.module.promotion092.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2021/3/11
 **/
@Setter
@Getter
@Entity
@Table(name = "promotion_092_start_time", comment = "活动时间")
public class Promotion092StartTime extends AbstractEntity {
    @Id
    @Column(name = "server_id", comment = "服务器id")
    private int serverId;

    @Column(name = "time", comment = "时间")
    private int time;

    @Column(name = "status", comment = "是否结算，0未结算，1结算")
    private int status;

    @Column(name = "record_time", comment = "结算时间")
    private int recordTime;
    @Column(name = "count_rank_record", comment = "次数结算记录")
    private List<RankData> countRankRecord = new ArrayList<>();
    @Column(name = "hero_rank_record", comment = "英雄结算记录")
    private List<RankData> heroRankRecord = new ArrayList<>();

}
