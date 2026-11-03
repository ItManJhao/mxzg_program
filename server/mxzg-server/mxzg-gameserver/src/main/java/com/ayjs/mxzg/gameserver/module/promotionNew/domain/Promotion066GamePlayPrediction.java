package com.ayjs.mxzg.gameserver.module.promotionNew.domain;


import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

/**
 * 功能预告活动
 *
 * @author hyx
 */
@Entity
@Table(name = "promotion066_game_play_prediction", comment = "功能预告活动")
@Getter
@Setter
public class Promotion066GamePlayPrediction extends AbstractEntity {

    @Id
    @Column(name = "rid", comment = "角色id")
    private long rid;

    @Column(name = "receive_time", comment = "上一次每日奖励领取时间")
    private int receiveTime;
}
