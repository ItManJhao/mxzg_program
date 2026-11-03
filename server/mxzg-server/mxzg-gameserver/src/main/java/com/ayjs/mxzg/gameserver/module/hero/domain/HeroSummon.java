/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

/**
 * 玩家的英雄系统数据表
 * @author YY
 *
 */
@Entity
@Table(name = "hero_summon", comment = "玩家的英雄系统数据表")
@Getter
@Setter
public class HeroSummon extends AbstractEntity {
	@Id
    @Column(name = "rid")
	private long rid;
	@Column(name = "summon_num", comment = "钻石抽的次数")
	private int summonNum;
	@Column(name = "guarantee_num", comment = "第几次10连抽")
	private int guaranteeNum;
	@Column(name = "senior_num", comment = "高级抽的历史次数，用于T1保底抽奖")
	private int seniorNum;
	
	@Column(name = "free_time", comment = "普通抽免费时间")
	private int freeTime;
	@Column(name = "senior_free_time", comment = "高级抽免费时间")
	private int seniorFreeTime;
	
	@Column(name = "first_normal", comment = "第一次普通抽")
	private int firstNormal;
	@Column(name = "first_senior", comment = "第一次高级抽")
	private int firstSenior;
	
	@Column(name = "buy_space_times", comment = "已经购买英雄背包的次数")
	private int buySpaceTimes;
	/**
	 * type -> kind -> miss number 类型 , 级别 , 遗漏次数
	 */
	@Column(name = "prophet_miss_times", comment = "先知召唤遗漏数据:类型,级别,遗漏次数")
	private Map<Integer, Map<Integer, Integer>> prophetMissTimes = new HashMap<>();
	@Column(name = "prophet_num", comment = "第几次先知召唤")
	private int prophetNum;
	/**
	 * star --> miss number 星级，抽取遗漏次数
	 */
	@Column(name = "senior_lower_upper", comment = "高抽保底上下限")
	private Map<Integer, Integer> seniorLowerUpper;
    /**
     * 等级重生次数
     */
    @Column(name = "level_reset_times", comment = "等级重生次数")
    private int levelResetTimes;
    /**
     * 等级重生次数重置时间戳
     */
    @Column(name = "level_reset_datetime", comment = "等级重生次数重置时间戳")
    private int levelResetDateTime;

	public int getProphetMissTimes(int type, int kind) {
		Map<Integer, Integer> kindMap = prophetMissTimes.getOrDefault(type, null);
		if (Objects.isNull(kindMap)) {
			return 0;
		}
		return kindMap.getOrDefault(kind, 0);
	}

	/**
	 * 遗漏次数加一
	 */
	public void incrementProphetMissTimes(int type, int kind) {
		Map<Integer, Integer> kindMap = prophetMissTimes.computeIfAbsent(type, k -> new HashMap<>());
		kindMap.compute(kind, (k, v) -> {
			if (Objects.isNull(v)) {
				return 1;
			} else {
				return v + 1;
			}
		});
	}

	/**
	 * 重置遗漏次数
	 */
	public void resetProphetMissTimes(int type, int kind) {
		prophetMissTimes.computeIfPresent(type, (k, v) -> {
			v.computeIfPresent(kind, (k1, v1) -> 0);
			return v;
		});
	}

}
