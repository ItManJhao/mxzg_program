package com.ayjs.mxzg.gameserver.log.pet.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

import java.lang.reflect.Type;

/**
 * 宠物删除日志
 * @author hyx
 */
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "pet_log", comment = "宠物删除日志")
@Getter
@Setter
public class PetLog extends AbstractOperateLog {

    @Column(name = "sys_id", comment = "宠物配置表id")
    private int sys_id;

    @Column(name = "pet_level",comment = "宠物等级")
    private int petLevel;

    @Column(name = "event", comment = "流水事件")
    private int event;

    @Column(name = "event_desc", comment = "流水描述")
    private String eventDesc;

    @Column(name = "type",comment = "操作类型，0:删除,1：添加")
    private int type;

    @ShardingId
    @Column(name = "time", comment = "日志时间", readOnly = true)
    private int time;

}
