package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.util.HashMap;
import java.util.Map;

@Data
@Entity
@Table(name = "promotion042_sacrifice_shop_buy",comment = "祭坛活动商品兑换")
public class Promotion042SacrificeShopBuy extends BaseLoopingPromotion {

    @Column(name = "buy_num",comment = "商品购买次数")
    private Map<Integer,Integer> buyMap = new HashMap<>();

}
