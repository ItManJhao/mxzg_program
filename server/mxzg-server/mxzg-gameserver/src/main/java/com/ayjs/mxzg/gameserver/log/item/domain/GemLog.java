/**
 * 
 */
package com.ayjs.mxzg.gameserver.log.item.domain;

import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.log.base.AbstractThingLog;

/**
 * @author YY
 *
 */
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "gem_log", comment = "钻石日志")
public class GemLog extends AbstractThingLog {
}
