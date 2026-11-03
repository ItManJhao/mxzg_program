/**
 * 
 */
package com.ayjs.mxzg.gameserver.log.clan.domain;

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
@Table(name = "clan_exp_log", comment = "公会经验日志")
@Setter
@Getter
public class ClanExpLog extends AbstractThingLog {
	@Column(name = "clan_id", comment = "公会ID")
	private long clanId;
	@Column(name = "old_lv", comment = "原等级")
	private int oldLv;
	@Column(name = "curr_lv", comment = "当前等级")
	private int currLv;
}
