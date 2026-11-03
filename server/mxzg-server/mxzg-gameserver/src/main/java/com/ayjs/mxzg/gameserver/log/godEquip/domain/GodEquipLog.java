/**
 * 
 */
package com.ayjs.mxzg.gameserver.log.godEquip.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.log.base.AbstractThingLog;

import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 *
 */
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "god_equip_log", comment = "神装装备日志")
@Setter
@Getter
public class GodEquipLog extends AbstractThingLog {
    @Column(name = "sys_id", comment = "神装类型")
    private int sysId;
    @Column(name = "part", comment = "神装部分")
    private int part;
}
