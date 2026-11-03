/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.godequip.domain;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;

import com.ayjs.mxzg.gameserver.module.godequip.struct.GodEquipRecord;
import com.google.errorprone.annotations.CanIgnoreReturnValue;
import lombok.Getter;
import lombok.Setter;
import org.checkerframework.checker.units.qual.C;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "god_equip_lottery_info", comment = "玩家的神装抽奖数据")
@Getter
@Setter
public class GodEquipLotteryInfo extends AbstractEntity {
	@Id
    @Column(name = "rid")
	private long rid;
	@Column(name = "lottery_count", comment = "神装抽奖次数")
	private int lotteryCount;
	@Column(name = "free_time",comment = "上一次免费抽时间")
	private int freeTime;
	@Column(name = "lottery_refresh", comment = "神装抽奖次数记录")
	private Map<Integer, Integer> lotteryRefresh = new HashMap<>();
	@Column(name = "records",comment = "个人抽奖记录")
	private List<GodEquipRecord> records = new ArrayList<>();
	@Column(name = "privilege",comment = "特权购买状态，1为解锁，0为未解锁")
	private int privilege;
	@Column(name = "receive_time",comment = "特权奖励领取时间")
	private int receiveTime;
	@Column(name = "receive_day",comment = "特权累计领取天数")
	private int receiveDay;
}
