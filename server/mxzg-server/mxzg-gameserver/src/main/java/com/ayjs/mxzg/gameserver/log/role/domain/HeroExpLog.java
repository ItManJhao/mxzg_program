/**
 * 
 */
package com.ayjs.mxzg.gameserver.log.role.domain;

import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.log.base.AbstractThingLog;

/**
 * @author YY
 *
 */
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "hero_exp_log", comment = "英雄经验日志")
public class HeroExpLog extends AbstractThingLog {

}
