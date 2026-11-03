/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

/**
 * cwj
 */
@Getter
@Setter
@Entity
@Table(name = "promotion054_flash_sale", comment = "限时抢购")
public class Promotion054FlashSale extends BaseLoopingPromotion {
    @Column(name = "buy_info", comment = "限时抢购，记录ID跟数量", length = 1000)
    private Map<Integer, Integer> buyInfo = new HashMap<>();
    @Column(name = "buy_round", comment = "购买轮次", length = 1000)
    private Map<Integer, Integer> buyRound = new HashMap<>();
//    @Column(name = "daily_refresh_date", comment = "每天刷新时间")
//    private LocalDate dailyRefreshDate = LocalDate.now();
//    @Column(name = "week_refresh_date", comment = "每周刷新时间")
//    private LocalDate weekRefreshDate = LocalDate.now();
}
