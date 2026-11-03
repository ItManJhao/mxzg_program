package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.util.HashSet;
import java.util.Set;

/**
 * 节日登陆赠礼(运营活动)
 *
 * @author hyx
 */
@Data
@Entity
@Table(name = "promotion051_festival_Login_gift", comment = "节日登陆赠礼")
public class Promotion051FestivalLoginGift extends BaseLoopingPromotion {

    @Column(name = "day", comment = "活动期间已登陆天数")
    private int day;

    @Column(name = "sign_In_time", comment = "上一次签到时间")
    private int time;

    @Column(name = "reward_list", comment = "已领取奖励集", length = 200)
    private Set<Integer> rewardList = new HashSet<>();

}
