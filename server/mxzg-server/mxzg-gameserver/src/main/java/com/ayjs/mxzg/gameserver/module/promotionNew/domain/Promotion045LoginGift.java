package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.util.HashSet;
import java.util.Set;

/**
 * 后台活动
 *
 * @Author: CWJ
 * @Date: 2019/10/22
 **/
@Table(name = "promotion045_login_gift", comment = "登录有礼")
@Data
@Entity
public class Promotion045LoginGift extends BaseLoopingPromotion {
    @Column(name = "login_days")
    private int loginDays;
    @Column(name = "reward_record")
    private Set<Integer> rewardRecord = new HashSet<>();
    @Column(name = "last_login_time")
    private int lastLoginTime;

}
