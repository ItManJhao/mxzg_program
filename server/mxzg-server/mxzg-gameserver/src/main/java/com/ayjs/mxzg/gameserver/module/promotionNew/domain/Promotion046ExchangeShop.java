package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.util.HashMap;
import java.util.Map;

/**
 * 后台活动
 *
 * @Author: CWJ
 * @Date: 2019/10/22
 **/
@Table(name = "promotion046_exchange_shop", comment = "碎片进化")
@Data
@Entity
public class Promotion046ExchangeShop extends BaseLoopingPromotion {
    @Column(name = "reward_record")
    private Map<Integer, Integer> rewardRecord = new HashMap<>();
}
