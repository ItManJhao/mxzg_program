/**
 * 
 */
package com.ayjs.mxzg.gameserver.log.battle.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

/**
 * 战斗日志
 */
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "battle_log", comment = "战斗日志")
@Setter
@Getter
public class BattleLog extends AbstractOperateLog {
	@Column(name = "opponent", comment = "对手ID")
	private long opponent;
	@Column(name = "battle_id", comment = "战斗id")
	private String battleId;
	@Column(name = "battle_type", comment = "战斗类型")
	private int battleType;
	@Column(name = "win", comment = "是否胜利")
	private boolean win;
	@ShardingId
	@Column(name = "time", comment = "战斗时间", readOnly = true)
	private int time;
}
