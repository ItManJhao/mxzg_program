/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.domain;

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.module.champion.IChampionCompetitor;


@Entity
@Table(name = "pinnacle_competitor", comment = "巅峰赛参赛玩家战斗信息", indexes = {
		@Index(name = "round", columnList = "round") }, cache = { @Cache(columns = "round") })
public class PinnacleCompetitor extends AbstractEntity implements IChampionCompetitor {
	@Id
    @Column(name = "id", comment = "唯一ID")
    @LongIdGenerate
	private long id;
	@Column(name = "round", comment = "巅峰赛轮数", readOnly = true)
	private int round;
	@Column(name = "rid", comment = "参赛者玩家ID")
	private long rid;
	@Column(name = "name", comment = "参赛者名字")
	private String name;
	@Column(name = "ori_point", comment = "原始积分点数")
	private int oriPoint;
	@Column(name = "point", comment = "积分点数")
	private int point;
	@Column(name = "battler_vo", comment = "战斗镜像")
	private BattlerVo battlerVo;
	@Column(name = "fighting", comment = "战斗镜像的战斗力")
	private int fighting;
	@Column(name = "trials_group", comment = "选拔赛分组，用于开服还原数据")
	private int trialsGroup;
	@Column(name = "trials_pos", comment = "选拔赛分组位置，前64或者后64，用于开服还原数据")
	private int trialsPos;
	@Column(name = "trials_index", comment = "选拔赛分组下标，用于开服还原数据")
	private int trialsIndex;
	@Column(name = "chaos_group", comment = "选拔赛乱战时对方的分组，用于开服还原数据")
	private int chaosGroup;
	@Column(name = "chaos_index", comment = "选拔赛乱战下标，用于开服还原数据")
	private int chaosIndex;
	@Column(name = "knockout_group", comment = "淘汰赛分组")
	private int knockoutGroup;
	@Column(name = "knockout_index", comment = "淘汰赛分组下标，用于开服还原数据")
	private int knockoutIndex;
	@Column(name = "robot", comment = "是否机器人，0不是，1是")
	private int robot;
	@Column(name = "knockout_win", comment = "淘汰赛胜利次数")
	private int knockoutWin;
	@Column(name = "rank", comment = "当前排名")
	private int rank;
	@Column(name = "level", comment = "等级")
	private int level;
	@Column(name = "head_id", comment = "头像")
	private int headId;
	@Column(name = "border_id", comment = "头像框")
	private int borderId;
	@Column(name = "server_id", comment = "服务器ID")
	private int serverId;

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
	public long getRid() {
		return rid;
	}
	public void setRid(long rid) {
		this.rid = rid;
	}
	public int getPoint() {
		return point;
	}
	public void setPoint(int point) {
		this.point = point;
	}
	public BattlerVo getBattlerVo() {
		return battlerVo;
	}
	public void setBattlerVo(BattlerVo battlerVo) {
		this.battlerVo = battlerVo;
	}
	public int getFighting() {
		return fighting;
	}
	public void setFighting(int fighting) {
		this.fighting = fighting;
	}
	public int getOriPoint() {
		return oriPoint;
	}
	public void setOriPoint(int oriPoint) {
		this.oriPoint = oriPoint;
	}
	public int getTrialsGroup() {
		return trialsGroup;
	}
	public void setTrialsGroup(int trialsGroup) {
		this.trialsGroup = trialsGroup;
	}
	public int getTrialsPos() {
		return trialsPos;
	}
	public void setTrialsPos(int trialsPos) {
		this.trialsPos = trialsPos;
	}
	public int getTrialsIndex() {
		return trialsIndex;
	}
	public void setTrialsIndex(int trialsIndex) {
		this.trialsIndex = trialsIndex;
	}
	public int getChaosGroup() {
		return chaosGroup;
	}
	public void setChaosGroup(int chaosGroup) {
		this.chaosGroup = chaosGroup;
	}
	public int getChaosIndex() {
		return chaosIndex;
	}
	public void setChaosIndex(int chaosIndex) {
		this.chaosIndex = chaosIndex;
	}
	public int getKnockoutGroup() {
		return knockoutGroup;
	}
	public void setKnockoutGroup(int knockoutGroup) {
		this.knockoutGroup = knockoutGroup;
	}
	public int getKnockoutIndex() {
		return knockoutIndex;
	}
	public void setKnockoutIndex(int knockoutIndex) {
		this.knockoutIndex = knockoutIndex;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getRobot() {
		return robot;
	}
	public void setRobot(int robot) {
		this.robot = robot;
	}
	public int getKnockoutWin() {
		return knockoutWin;
	}
	public void setKnockoutWin(int knockoutWin) {
		this.knockoutWin = knockoutWin;
	}
	public int getRank() {
		return rank;
	}
	public void setRank(int rank) {
		this.rank = rank;
	}
	public int getLevel() {
		return level;
	}
	public void setLevel(int level) {
		this.level = level;
	}
	public int getHeadId() {
		return headId;
	}
	public void setHeadId(int headId) {
		this.headId = headId;
	}
	public int getBorderId() {
		return borderId;
	}
	public void setBorderId(int borderId) {
		this.borderId = borderId;
	}
	public int getServerId() {
		return serverId;
	}
	public void setServerId(int serverId) {
		this.serverId = serverId;
	}
	@Override
	public int getCrossGroup() {
		return 0;
	}
}
