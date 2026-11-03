package com.ayjs.mxzg.gameserver.module.promotionNew.domain;


import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.Promotion067WeekendKoiInfo;
import lombok.Getter;
import lombok.Setter;
import java.util.concurrent.CopyOnWriteArrayList;


/**
 * @author hyx
 */

@Entity
@Table(name = "promotion067_weekend_koi_sys_info", comment = "周末锦鲤活动数据")
@Getter
@Setter
public class Promotion067WeekendKoiSysInfo extends AbstractEntity {

    @Id
    @Column(name = "id",comment = "主键id")
    private long id = 1;

    @Column(name = "turns",comment = "本期轮次")
    private int turns;

    @Column(name = "start_time",comment = "开始时间")
    private int startTime;

    @Column(name = "koi",comment = "本期中奖玩家id")
    private long koi;

    @Column(name = "phase",comment ="当前是第几期")
    private int phase;

    @Column(name = "buy_list",comment = "购买礼包的玩家id")
    private CopyOnWriteArrayList<Long> buyList = new CopyOnWriteArrayList<>();

    @Column(name = "blessing_records",comment = "活动内玩家赐福记录")
    private CopyOnWriteArrayList<Promotion067WeekendKoiInfo> blessingRecords = new CopyOnWriteArrayList<>();
}
