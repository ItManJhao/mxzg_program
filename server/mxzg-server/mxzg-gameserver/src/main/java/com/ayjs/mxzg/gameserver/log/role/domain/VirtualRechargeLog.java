/**
 * 
 */
package com.ayjs.mxzg.gameserver.log.role.domain;

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
@Getter
@Setter
@Sharding(strategy = Sharding.Strategy.DATE, period = Sharding.Period.MONTHLY)
@Table(name = "virtual_recharge_log", comment = "虚拟充值日志")
public class VirtualRechargeLog extends AbstractOperateLog {
	@Column(name = "product_id", comment = "充值商品ID")
	private int productId;
	@ShardingId
	@Column(name = "time", comment = "操作的时间", readOnly = true)
	private int time;
	@Column(name = "success", comment = "是否成功，1成功，0失败")
	private int success;
	@Column(name = "card", comment = "是否是道具卡，0不是，1是")
	private int card;

}
