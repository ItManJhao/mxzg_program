package com.ayjs.mxzg.gameserver.module.promotionNew.domain;


import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.util.HashSet;
import java.util.Set;


/**
 * 占星阵活动任务数据
 */
@Data
@Entity
@Table(name = "promotion038_astrology",comment = "占星阵活动")
public class Promotion038Astrology extends BaseLoopingPromotion {

    @Column(name = "reward_idx",comment = "已完成的任务奖励集")
    private Set<Integer> rewardList = new HashSet<>();

}
