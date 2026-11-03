/**
 * 
 */
package com.ayjs.mxzg.gameserver.log.base;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.MappedSuperclass;
import com.ayjs.mxzg.common.persistence.annotation.ShardingId;
import com.ayjs.mxzg.template.log.AbstractOperateLog;
import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 * 物品消耗基类
 */
@MappedSuperclass
@Setter
@Getter
public abstract class AbstractThingLog extends AbstractOperateLog {
	@Column(name = "delta", comment = "变化量")
	private long delta;
	@Column(name = "curr", comment = "变化量后的当前量")
	private long curr;
	@ShardingId
	@Column(name = "time", comment = "日志时间", readOnly = true)
	private int time;
	@Column(name = "event", comment = "流水事件")
	private int event;
	@Column(name = "event_desc", comment = "流水描述")
	private String eventDesc;
}
