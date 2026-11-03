/**
 * 
 */
package com.ayjs.mxzg.gameserver.log.hero.domain;

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
@Table(name = "hero_fighting_log", comment = "英雄战力日志")
@Setter
@Getter
public class HeroFightingLog extends AbstractThingLog {
	@Column(name = "hero_id", comment = "英雄ID")
	private long heroId;
}
