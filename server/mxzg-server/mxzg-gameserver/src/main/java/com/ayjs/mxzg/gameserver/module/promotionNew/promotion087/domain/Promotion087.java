package com.ayjs.mxzg.gameserver.module.promotionNew.promotion087.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.BaseLoopingPromotion;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "promotion087", comment = "圣诞抽奖")
public class Promotion087 extends BaseLoopingPromotion {
    @Column(name = "lottery_record", comment = "抽奖记录")
    private List<Integer> lotteryRecord = new ArrayList<>();

    @Column(name = "lottery_type", comment = "抽奖类型")
    private int lotteryType;

}
