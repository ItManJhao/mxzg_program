package com.ayjs.mxzg.gameserver.module.promotionNew.promotion092.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.BaseLoopingPromotion;
import com.ayjs.mxzg.message.module.promotion092.struct.DeliverData;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "promotion092", comment = "女神献花")
public class Promotion092 extends BaseLoopingPromotion {
    @Column(name = "count", comment = "献花次数")
    private int count;

    @Column(name = "rank_time", comment = "上榜时间")
    private LocalDateTime rankTime = LocalDateTime.of(1970, 1, 1, 0, 0);

    @Column(name = "deliver_date", comment = "英雄献花数据")
    private List<DeliverData> deliverData = new ArrayList<>();

    @Column(name = "count_reward_record", comment = "次数领奖记录")
    private List<Integer> countRewardRecord = new ArrayList<>();

    @Column(name = "buy_count", comment = "献花购买次数")
    private int buyCount;

}
