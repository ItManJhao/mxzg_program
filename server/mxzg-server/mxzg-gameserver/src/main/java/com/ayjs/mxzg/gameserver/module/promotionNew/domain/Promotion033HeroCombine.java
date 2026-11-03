package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;

import java.util.HashMap;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2019/10/23
 **/
@Entity
@Data
@Table(name = "promotion033_hero_combine", comment = "合成觉醒")
public class Promotion033HeroCombine extends BaseRankablePormotion {

    @Column(name = "reward_record", comment = "领奖记录")
    private Map<Integer, Integer> rewardRecord = new HashMap<>();
    @Column(name = "count_record", comment = "计数",length = 1024)
    private Map<Integer, Integer> countRecord = new HashMap<>();
}
