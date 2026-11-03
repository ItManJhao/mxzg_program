/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

import java.util.ArrayList;
import java.util.List;

import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Table;

import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 * 新英雄抽卡
 */
@Entity
@Table(name = "promotion065_hero_rolling", comment = "新英雄抽卡活动")
@Getter
@Setter
public class Promotion065HeroRolling extends BaseLoopingPromotion {
	@Column(name = "summon_index", comment = "必出新英雄的目标次数配置下标")
	private int summonIndex;
	@Column(name = "summon_num", comment = "新英雄抽卡已抽奖次数")
	private int summonNum;
	@Column(name = "his_num", comment = "本次活动一共抽奖了多少次")
	private int hisNum;
	@Column(name = "rewards", comment = "新英雄抽卡已领取奖励")
	private List<Integer> rewards = new ArrayList<>();
	@Column(name = "trigger_num", comment = "N次不出5星英雄必出5星的保底次数")
	private int triggerNum;
	@Column(name = "free_time", comment = "下一次免费单抽的时间")
	private int freeTime;
	@Column(name = "cheat_num", comment = "作弊出现的次数")
	private int cheatNum;
	@Column(name = "cheat_state", comment = "作弊生效的状态，0未生效，1已生效")
	private int cheatState;
}
