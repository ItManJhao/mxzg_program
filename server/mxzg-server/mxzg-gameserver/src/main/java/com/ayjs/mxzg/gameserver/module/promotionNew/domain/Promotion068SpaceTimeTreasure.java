package com.ayjs.mxzg.gameserver.module.promotionNew.domain;


import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * @author hyx
 */
@Entity
@Table(name = "promotion068_space_time_treasure", comment = "时空异宝")
@Getter
@Setter
public class Promotion068SpaceTimeTreasure extends BaseLoopingPromotion {

    @Column(name = "choose_time",comment = "当天奖励选择的时间")
    private int chooseTime;

    @Column(name = "idx_list", comment = "当天选择的奖励配置表idx")
    private List<Integer> idxList = new ArrayList<>();


}
