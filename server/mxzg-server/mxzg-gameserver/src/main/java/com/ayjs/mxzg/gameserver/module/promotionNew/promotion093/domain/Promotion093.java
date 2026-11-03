package com.ayjs.mxzg.gameserver.module.promotionNew.promotion093.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.BaseLoopingPromotion;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Getter
@Setter
@Entity
@Table(name = "promotion093", comment = "春日踏青")
public class Promotion093 extends BaseLoopingPromotion {
    @Column(name = "scenic_count", comment = "景点次数")
    private Map<Integer, Integer> scenicCount = new HashMap<>();
    @Column(name = "scenic_reward", comment = "景点领取记录")
    private List<Integer> scenicReward = new ArrayList<>();
    @Column(name = "dice_group", comment = "骰子组数")
    private int diceGroup;
    @Column(name = "dice_count", comment = "本组次数")
    private int diceCount;
    @Column(name = "curr_idx", comment = "当前位置")
    private int currIdx;

    public void addCount(int type, int addValue) {
        scenicCount.put(type, scenicCount.getOrDefault(type, 0) + addValue);
    }

}
