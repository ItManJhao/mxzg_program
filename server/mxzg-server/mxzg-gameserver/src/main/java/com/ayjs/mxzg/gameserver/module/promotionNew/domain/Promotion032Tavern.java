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
 * @Author: CWJ
 * @Date: 2019/10/23
 **/
@Entity
@Table(name = "promotion032_tavern", comment = "酒馆达标")
@Data
public class Promotion032Tavern extends BaseLoopingPromotion {
    @Column(name = "count_map", comment = "计数值",length = 1024)
    private Map<Integer, Integer> countMap = new HashMap<>();
    @Column(name = "reward_map", comment = "领奖记录")
    private Set<Integer> rewardMap = new HashSet<>();
}
