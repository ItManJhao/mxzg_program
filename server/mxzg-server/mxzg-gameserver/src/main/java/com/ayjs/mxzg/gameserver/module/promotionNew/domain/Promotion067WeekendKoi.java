package com.ayjs.mxzg.gameserver.module.promotionNew.domain;


import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;



/**
 * @author hyx
 */

@Entity
@Table(name = "promotion067_weekend_koi", comment = "周末锦鲤")
@Getter
@Setter
public class Promotion067WeekendKoi extends BaseLoopingPromotion {

    @Column(name = "blessing_num", comment = "赐福已使用次数")
    private int blessingNum;

    @Column(name = "show_num", comment = "奖池道具出现次数")
    private Map<Integer, Integer> showMap = new HashMap<>();

    @Column(name = "buy_num", comment = "礼包购买次数")
    private int buyNum;
}

