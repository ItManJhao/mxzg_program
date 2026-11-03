package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;

@Getter
@Setter
@Entity
@Table(name = "promotion075_mid_food", comment = "赏月佳肴")
public class Promotion075MidFood extends BaseLoopingPromotion {
    @Column(name = "buy_list", comment = "已购买次数")
    private Map<Integer, Integer> buyList = new HashMap<>();
}
