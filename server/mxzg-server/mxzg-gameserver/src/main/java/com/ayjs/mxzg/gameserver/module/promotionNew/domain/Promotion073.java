package com.ayjs.mxzg.gameserver.module.promotionNew.domain;


import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "promotion073", comment = "重置双倍购买活动")
@Getter
@Setter
public class Promotion073 extends BaseLoopingPromotion {

}
