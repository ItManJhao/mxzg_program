package com.ayjs.mxzg.gameserver.module.promotionNew.promotion076.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.BaseLoopingPromotion;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MissionInfo;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Entity
@Table(name = "promotion076", comment = "永久皮肤")
@Getter
@Setter
public class Promotion076 extends BaseLoopingPromotion {

    @Column(name = "fashion_count_record", comment = "皮肤数量领取记录")
    private List<Integer> fashionCountRecord = Lists.newArrayList();

}
