/**
 *
 */
package com.ayjs.mxzg.gameserver.module.blessingPool.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * 许愿池
 */
@Getter
@Setter
@Entity
@Table(name = "blessing_pool", comment = "许愿池",
		indexes = {@Index(name = "idx_rid", columnList = {"rid"})},
		cache = {@Cache(columns = "rid")})
public class BlessingPool extends AbstractEntity {

	@Id
	@LongIdGenerate
	@Column(name = "id")
	private long id;
	/**
	 * 角色Id
	 */
	@Column(name = "rid", readOnly = true, comment = "角色Id")
	private long rid;
	/**
	 * 许愿池类型 1常规 2高级
	 */
	@Column(name = "pool_type", comment = "许愿池类型 1常规 2高级")
	private int poolType;
	/**
	 * 道具:key位置value道具
	 */
	@Column(name = "item_data", comment = "道具:key位置value道具", length = 1024)
	private Map<Integer, BlessingPoolItemData> itemData;
	/**
	 * 刷新时间
	 */
	@Column(name = "refresh_datetime", comment = "刷新时间")
	private int refreshDatetime;
	/**
	 * 刷新次数
	 */
	@Column(name = "refresh_times", comment = "刷新次数")
	private int refreshTimes;

	@Column(name = "lucky_value",comment = "幸运值")
	private int luckyValue;

	@Column(name = "lucky_reward_id",comment = "幸运值领奖记录")
	private Set<Integer> luckyRewardIds=new HashSet<>();

	@Column(name = "reset_time", comment = "许愿池重置时间")
	private long resetTime;

}
