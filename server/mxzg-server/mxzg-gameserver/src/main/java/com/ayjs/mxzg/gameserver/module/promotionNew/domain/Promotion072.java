package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.protocol.Promotion072GMsg;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "promotion072_zhu_shen_ji_tan", comment = "诸神祭坛")
public class Promotion072 extends BaseLoopingPromotion {

    @Column(name = "floor", comment = "当前层数")
    private int floor = 1;//当前层数
    @Column(name = "luckdrawnum", comment = "该层抽奖次数")
    private int luckDrawNum = 0;//抽奖次数
    @Column(name = "money_drawnum", comment = "货币抽奖次数")
    private int moneyDrawNum = 0;
    @Column(name = "money_drawtime", comment = "货币抽奖时间")
    private long moneyDrawTime = System.currentTimeMillis();

}
