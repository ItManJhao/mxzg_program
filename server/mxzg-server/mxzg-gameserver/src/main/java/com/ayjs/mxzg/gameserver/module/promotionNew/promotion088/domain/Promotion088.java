package com.ayjs.mxzg.gameserver.module.promotionNew.promotion088.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.BaseLoopingPromotion;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "promotion088", comment = "圣诞礼盒")
public class Promotion088 extends BaseLoopingPromotion {
    @Column(name = "score", comment = "积分")
    private int score;

}
