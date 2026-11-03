package com.ayjs.mxzg.gameserver.module.promotionNew.promotion086.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.BaseLoopingPromotion;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;

@Getter
@Setter
@Entity
@Table(name = "promotion086", comment = "圣诞礼包")
public class Promotion086 extends BaseLoopingPromotion {
    @Column(name = "buy_list", comment = "已购买次数")
    private Map<Integer, Integer> buyList = new HashMap<>();
}
