/**
 * 
 */
package com.ayjs.mxzg.gameserver.log.hero.domain;

import java.util.List;

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
@Table(name = "hero_train_log", comment = "英雄养成日志")
@Setter
@Getter
public class HeroTrainLog extends AbstractThingLog {
	@Column(name = "hero_id", comment = "英雄ID")
	private long heroId;
	@Column(name = "ori_level", comment = "原等级")
	private int oriLevel;
	@Column(name = "curr_level", comment = "当前等级")
	private int currLevel;
	@Column(name = "ori_stage", comment = "原阶级")
	private int oriStage;
	@Column(name = "curr_stage", comment = "当前阶级")
	private int currStage;
	@Column(name = "ori_star", comment = "原星级")
	private int oriStar;
	@Column(name = "curr_star", comment = "当前阶级")
	private int currStar;
	@Column(name = "costs", comment = "消耗", length = 500)
	private String costs;
	@Column(name = "rewards", comment = "获得", length = 500)
	private String rewards;
	@Column(name = "cost_heros", comment = "消耗的英雄")
	private List<Long> costHeros;
}
