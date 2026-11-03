package com.ayjs.mxzg.gameserver.log.reikiEquip.domain;


import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.log.base.AbstractThingLog;
import lombok.Getter;
import lombok.Setter;

/**
 * 灵器日志
 * @author hyx
 */
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "reiki_equip_log", comment = "灵器装备日志")
@Setter
@Getter
public class ReikiEquipLog extends AbstractThingLog {

    @Column(name = "sys_id", comment = "灵器类型")
    private int sysId;
    @Column(name = "part", comment = "灵器部位")
    private int part;

}
