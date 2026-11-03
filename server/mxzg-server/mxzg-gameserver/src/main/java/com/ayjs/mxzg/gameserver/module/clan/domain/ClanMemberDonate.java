/*
 * Welcome to use the TableGo Tools.
 * 
 * http://www.tablego.cn
 * 
 * http://vipbooks.iteye.com
 * http://blog.csdn.net/vipbooks
 * http://www.cnblogs.com/vipbooks
 * 
 * Author: bianj
 * Email: tablego@qq.com
 * Version: 6.4.0
 */
package com.ayjs.mxzg.gameserver.module.clan.domain;

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
 * 公会捐献
 */
@Entity
@Table(name = "clan_member_donate")
@Getter
@Setter
public class ClanMemberDonate extends AbstractEntity {

	@Id
	@Column(name = "rid")
    private long rid;
	
	@Column(name = "daily_time", comment = "每日重置时间")
	private int dailyTime;
	
	@Column(name = "donate_thing", comment = "当前捐献的类型")
	private int donateThing;
	
	@Column(name = "donate_reward", comment = "今天已领取的捐献奖励")
	private List<Integer> donateReward = new ArrayList<>();
	
	@Column(name = "quit_clan_time")
	private int quitClanTime;
}