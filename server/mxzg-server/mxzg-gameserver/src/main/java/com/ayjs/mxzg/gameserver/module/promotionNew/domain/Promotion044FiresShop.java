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
@Table(name = "promotion044_fires_shop", comment = "七彩华章")
@Data
@Entity
public class Promotion044FiresShop extends BaseLoopingPromotion implements IPromotionDropsDomain {

    @Column(name = "last_drop_time", comment = "上一次稳定掉落的时间")
    private int lastDropTime;
    @Column(name = "fires_shop_info", length = 1000)
    private Map<Integer, Integer> firesShopInfo = new HashMap<>();

}
