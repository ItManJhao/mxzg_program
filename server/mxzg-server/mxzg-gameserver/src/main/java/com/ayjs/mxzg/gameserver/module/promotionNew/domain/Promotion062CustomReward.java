package com.ayjs.mxzg.gameserver.module.promotionNew.domain;


import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.CustomRewardData;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;

@Getter
@Setter
@Entity
@Table(name = "promotion062_custom_reward", comment = "私人定制")
public class Promotion062CustomReward extends BaseLoopingPromotion {

    @Column(name = "custom_data", comment = "定制奖励")
    private Map<Integer, CustomRewardData> customData=new HashMap<>();

}
