package com.ayjs.mxzg.largecross.module.floatingIslands.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankDataRecord;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/4/11
 **/
@Getter
@Setter
@Table(name = "floating_islands_rank_settle_record", comment = "浮空岛结算记录",
        indexes = {@Index(name = "group_id", columnList = {"group_id"})}, cache = {@Cache(columns = "group_id")})
public class FloatingIslandsRankSettleRecord extends AbstractEntity {
    @Id
    @LongIdGenerate
    @Column(name = "id", comment = "标识")
    private long id;

    @Column(name = "group_id", comment = "所属组", readOnly = true)
    private int groupId;

    @Column(name = "settle_time", comment = "结算时间")
    private int settleTime;

    @Column(name = "ranks", comment = "排名数据")
    private List<RankDataRecord> ranks = new ArrayList<>();

    @Column(name = "total_dmg", comment = "总伤害")
    private long totalDmg;

}
