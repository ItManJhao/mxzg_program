package com.ayjs.mxzg.gameserver.log.pet.domain;


import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "pet_up_level_log", comment = "宠物升级日志")
@Getter
@Setter
public class PetUpLevelLog extends AbstractOperateLog {

    @Column(name = "pet_id",comment = "宠物id")
    private long petId;

    @Column(name = "sys_id", comment = "宠物配置表id")
    private int sysId;

    @Column(name = "new_level",comment = "宠物新等级")
    private int newLevel;

    @ShardingId
    @Column(name = "time", comment = "日志时间", readOnly = true)
    private int time;

}
