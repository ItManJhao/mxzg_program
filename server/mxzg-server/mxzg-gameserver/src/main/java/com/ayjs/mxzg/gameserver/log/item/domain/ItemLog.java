/**
 *
 */
package com.ayjs.mxzg.gameserver.log.item.domain;

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
@Table(name = "item_log", comment = "道具日志")
@Setter
@Getter
public class ItemLog extends AbstractThingLog {
    @Column(name = "type", comment = "物品类型")
    private int type;
    @Column(name = "name", comment = "物品名字")
    private String name;
}
