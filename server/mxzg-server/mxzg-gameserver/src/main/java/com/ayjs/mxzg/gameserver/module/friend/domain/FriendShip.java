/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.friend.domain;

import java.util.HashSet;
import java.util.Set;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "friend_ship", comment = "玩家自身的好友信息")
public class FriendShip extends AbstractEntity {
	@Id
	@Column(name = "rid", comment = "")
	private long rid;
	@Column(name = "friend_ship", comment = "角色友情点")
	private int friendShip;
	@Column(name = "befall", comment = "今日降临获得友情点")
	private int befall;
	@Column(name = "adventure", comment = "今日探险获得友情点")
	private int adventure;
	@Column(name = "receive_num", comment = "领取好友赠好奖励次数。上限为20次")
	private int receiveNum;
	@Column(name = "daily_time", comment = "每日重置时间")
	private int dailyTime;
	@Column(name = "give_friends", comment = "今天已经赠送过礼物的好友")
	private Set<Long> giveFriends = new HashSet<>();
	
	public long getRid() {
		return rid;
	}
	public void setRid(long rid) {
		this.rid = rid;
	}
	public int getFriendShip() {
		return friendShip;
	}
	public void setFriendShip(int friendShip) {
		this.friendShip = friendShip;
	}
	public int getBefall() {
		return befall;
	}
	public void setBefall(int befall) {
		this.befall = befall;
	}
	public int getAdventure() {
		return adventure;
	}
	public void setAdventure(int adventure) {
		this.adventure = adventure;
	}
	public int getReceiveNum() {
		return receiveNum;
	}
	public void setReceiveNum(int receiveNum) {
		this.receiveNum = receiveNum;
	}
	public int getDailyTime() {
		return dailyTime;
	}
	public Set<Long> getGiveFriends() {
		return giveFriends;
	}
	public void setDailyTime(int dailyTime) {
		this.dailyTime = dailyTime;
	}
	public void setGiveFriends(Set<Long> giveFriends) {
		this.giveFriends = giveFriends;
	}
}
