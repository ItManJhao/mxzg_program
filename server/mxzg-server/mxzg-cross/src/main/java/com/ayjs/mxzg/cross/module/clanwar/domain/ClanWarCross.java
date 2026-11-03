/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanwar.domain;

import java.util.Set;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;

/**
 * @author YY
 * 公会战匹配时的信息
 */
@Entity
@Table(name = "clanwar_cross", comment = "公会战在跨服上的数据", indexes = {
		@Index(name = "roundClan", columnList = { "round", "clan_id" }) }, cache = {
				@Cache(columns = { "round", "clan_id" }) })
public class ClanWarCross extends AbstractEntity {
	@Id
	@Column(name = "id", comment = "唯一ID")
	@LongIdGenerate
	private long id;
	@Column(name = "round", comment = "公会战轮数", readOnly = true)
	private int round;
	@Column(name = "clan_id", comment = "公会ID", readOnly = true)
	private long clanId;
	@Column(name = "name", comment = "公会名字")
	private String name;
	@Column(name = "target_clan_id", comment = "对方的公会ID")
	private long targetClanId;
	@Column(name = "active_members", comment = "活跃人数")
	private int activeMembers;
	@Column(name = "fighting", comment = "公会战斗力")
	private long fighting;
	@Column(name = "join_members", comment = "本轮公会战可参战的成员ID集合", length = 1000)
	private Set<Long> joinMembers;
	@Column(name = "main_attack", comment = "是否主攻方，0不是，1是")
	private int mainAttack;
	@Column(name = "break_castle", comment = "攻破对方城堡的路号")
	private Set<Integer> breakCastle;
	@Column(name = "battle_members", comment = "本轮公会战参战的成员ID集合", length = 1000)
	private Set<Long> battleMembers;
	@Column(name = "server_id", comment = "服务器ID")
	private int serverId;
	@Column(name = "settle_status", comment = "是否已经结算本轮公会战，0未结算，1已结算")
	private int settleStatus;
	@Column(name = "is_win", comment = "是否胜利，0未出胜负，1胜利，2失败")
	private int isWin;
	@Column(name = "report_status", comment = "游戏服回报的发奖状态，0未回报，1已回报")
	private int reportStatus;
	
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public int getRound() {
		return round;
	}
	public void setRound(int round) {
		this.round = round;
	}
	public long getClanId() {
		return clanId;
	}
	public void setClanId(long clanId) {
		this.clanId = clanId;
	}
	public long getFighting() {
		return fighting;
	}
	public void setFighting(long fighting) {
		this.fighting = fighting;
	}
	public Set<Long> getJoinMembers() {
		return joinMembers;
	}
	public void setJoinMembers(Set<Long> joinMembers) {
		this.joinMembers = joinMembers;
	}
	public int getMainAttack() {
		return mainAttack;
	}
	public void setMainAttack(int mainAttack) {
		this.mainAttack = mainAttack;
	}
	public Set<Integer> getBreakCastle() {
		return breakCastle;
	}
	public void setBreakCastle(Set<Integer> breakCastle) {
		this.breakCastle = breakCastle;
	}
	public Set<Long> getBattleMembers() {
		return battleMembers;
	}
	public void setBattleMembers(Set<Long> battleMembers) {
		this.battleMembers = battleMembers;
	}
	public int getActiveMembers() {
		return activeMembers;
	}
	public void setActiveMembers(int activeMembers) {
		this.activeMembers = activeMembers;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getServerId() {
		return serverId;
	}
	public void setServerId(int serverId) {
		this.serverId = serverId;
	}
	public long getTargetClanId() {
		return targetClanId;
	}
	public void setTargetClanId(long targetClanId) {
		this.targetClanId = targetClanId;
	}
	public int getSettleStatus() {
		return settleStatus;
	}
	public void setSettleStatus(int settleStatus) {
		this.settleStatus = settleStatus;
	}
	public int getIsWin() {
		return isWin;
	}
	public void setIsWin(int isWin) {
		this.isWin = isWin;
	}
	public int getReportStatus() {
		return reportStatus;
	}
	public void setReportStatus(int reportStatus) {
		this.reportStatus = reportStatus;
	}
}
