/**
 * 
 */
package com.ayjs.mxzg.gameserver.log.rune.domain;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Sharding;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 *
 */
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "rune_log", comment = "精灵日志")
@Getter
@Setter
public class RuneLog extends AbstractOperateLog {

	@Column(name = "type", comment = "英雄类型")
	private int type;
	@Column(name = "ability_id", comment = "能力ID")
	private int abilityId;
	@Column(name = "skill", comment = "技能信息，位置信息+技能信息")
	private String skillMap;
	@Column(name = "event", comment = "流水事件")
	private int event;
	@ShardingId
	@Column(name = "time", comment = "日志时间", readOnly = true)
	private int time;
	@Column(name = "delta", comment = "变化量")
	private int delta;
	@Column(name = "event_desc", comment = "流水描述")
	private String eventDesc;
	
}
