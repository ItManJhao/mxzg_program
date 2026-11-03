/**
 * 
 */
package com.ayjs.mxzg.cross.log.champion.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.cross.log.base.AbstractThingLog;

import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 *
 */
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "champion_guess_coin_log", comment = "道具日志")
@Setter
@Getter
public class ChampionCrossGuessCoinLog extends AbstractThingLog {
	@Column(name = "period", comment = "赛程")
	private int period;
	@Column(name = "battle_round", comment = "进行到的对战轮数")
	private int battleRound;
	@Column(name = "which_win", comment = "结果哪一边赢")
	private int whichWin;
	@Column(name = "guess_type", comment = "竞猜哪一边赢")
	private int guessType;
	@Column(name = "round", comment = "第几届")
	private int round;
	@Column(name = "cross_group", comment = "跨服分组ID")
	private int crossGroup;
}
