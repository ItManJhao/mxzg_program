package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.util.HashMap;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/3/25
 **/
@Table(name = "promotion056_fashion_buy", comment = "皮肤购买活动")
@Entity
@Data
public class Promotion056FashionBuy extends BaseLoopingPromotion {
    @Column(name = "buy_count", comment = "购买记录")
    private Map<Integer, Integer> buyCount = new HashMap<>();

}
