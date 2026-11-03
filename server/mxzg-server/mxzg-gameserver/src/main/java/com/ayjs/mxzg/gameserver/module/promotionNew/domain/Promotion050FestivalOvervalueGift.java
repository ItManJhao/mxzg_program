package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * 节日礼包(运营活动)
 *
 * @author hyx
 */
@Data
@Entity
@Table(name = "promotion050_festival_overvalue_gift", comment = "节日豪礼")
public class Promotion050FestivalOvervalueGift extends BaseLoopingPromotion {

    @Column(name = "receive_day", comment = "超值礼包已领取天数")
    private int receiveDay;

    @Column(name = "buy_Gift", comment = "已购买的礼包idx")
    private Set<Integer> buyGift = new HashSet<>();
}
