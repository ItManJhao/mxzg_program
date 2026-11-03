package com.ayjs.mxzg.gameserver.log.weekendkoi.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.persistence.log.AbstractLog;
import lombok.Getter;
import lombok.Setter;


@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "weekend_koi_log", comment = "锦鲤大奖获得日志")
@Setter
@Getter
public class WeekendKoiLog extends AbstractLog {

    @Id
    @Column(name = "id", comment = "邮件ID")
    @LongIdGenerate
    private long id;

    @Column(name = "start_time", comment = "活动开启时间")
    private int startTime;

    @Column(name = "turns", comment = "活动配置轮次")
    private int turns;

    @Column(name = "phase",comment ="当前服活动开启第几期")
    private int phase;

    @Column(name = "koi_rid",comment = "大奖获得玩家id")
    private long koiRid;

    @ShardingId
    @Column(name = "time", comment = "日志时间", readOnly = true)
    private int time;

    @Override
    public Long getId() {
        return id;
    }

    @Override
    public void setId(Long id) {
        this.id = id;
    }


}
