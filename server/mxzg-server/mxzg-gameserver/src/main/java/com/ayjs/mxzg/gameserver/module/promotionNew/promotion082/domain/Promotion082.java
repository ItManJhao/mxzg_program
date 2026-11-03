package com.ayjs.mxzg.gameserver.module.promotionNew.promotion082.domain;

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
@Table(name = "promotion082", comment = "黑五礼包")
public class Promotion082 extends BaseLoopingPromotion {
    @Column(name = "buy_list", comment = "已购买次数")
    private Map<Integer, Integer> buyList = new HashMap<>();
}
