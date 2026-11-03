package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.util.HashMap;
import java.util.Map;

@Data
@Entity
@Table(name = "promotion039_overvalue_gift",comment = "超值礼包购买列表")
public class Promotion039OvervalueGift extends BaseLoopingPromotion {

    @Column(name = "buy_limit",comment = "礼包购买次数集")
    private Map<Integer,Integer> buyMap = new HashMap<>();
}
