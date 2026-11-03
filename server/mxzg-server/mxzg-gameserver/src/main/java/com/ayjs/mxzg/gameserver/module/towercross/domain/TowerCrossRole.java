/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.towercross.domain;

import java.util.ArrayList;
import java.util.List;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;

import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "tower_cross_role", comment = "跨服爬塔个人信息")
@Getter
@Setter
public class TowerCrossRole extends AbstractEntity {
	@Id
    @Column(name = "rid", comment = "玩家ID")
	private long rid;
	@Column(name = "round", comment = "当前届数")
	private int round;
	@Column(name = "curr_layer", comment = "当前已通关最高层数")
	private int currLayer;
	@Column(name = "his_layer", comment = "历史已通关最高层数")
	private int hisLayer;
	@Column(name = "daily_time", comment = "每日重置时间")
	private int dailyTime;
	@Column(name = "fail_num", comment = "当天已失败次数")
	private int failNum;
	@Column(name = "week_pass", comment = "本周通关层数")
	private int weekPass;
	@Column(name = "mark", comment = "小怪关卡的分数")
	private List<Integer> mark = new ArrayList<>();
}
