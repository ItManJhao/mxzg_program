package com.ayjs.mxzg.gameserver.module.promotionNew.domain;


import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Data
@Entity
@Table(name = "promotion043_summon_crystal" ,comment = "召唤水晶进度表")
public class Promotion043SummonCrystal extends BaseLoopingPromotion {

    @Column(name = "progress",comment = "任务进度")
    public Map<Integer,Integer> progressMap = new HashMap<>();

    @Column(name = "reward_idx",comment = "奖励领取详情")
    public List<Integer> rewardList = new ArrayList<>();
}
