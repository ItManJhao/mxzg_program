/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanworldboss.domain;

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.cross.module.clanworldboss.struct.ClanWorldRobRecord;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "clanworldboss_member", comment = "公会世界BOSS参战公会成员", indexes = {@Index(name = "round", columnList = {"round"})})
@Getter
@Setter
public class ClanWorldBossMember extends AbstractEntity {
	@Id
	@Column(name = "rid")
	private long rid;
	@Column(name = "clan_id", comment = "公会ID")
	private long clanId;
	@Column(name = "round", comment = "参与的轮数")
	private int round;
	@Column(name = "damage", comment = "造成的总伤害")
	private long damage;
	@Column(name = "point", comment = "获得的积分")
	private long point;
	@Column(name = "challenge_count", comment = "已挑战的次数")
	private int challengeCount;
	@Column(name = "challenge_cd", comment = "挑战的冷却时间")
	private int challengeCd;
	@Column(name = "rob_count", comment = "已掠夺的次数")
	private int robCount;
	@Column(name = "rob_cd", comment = "掠夺的冷却时间")
	private int robCd;
	@Column(name = "robing_roles", comment = "可以掠夺的玩家<玩家ID，服务器ID>")
	private List<Long> robingRoles;
	@Column(name = "point_time", comment = "最后一次获得积分的时间")
	private int pointTime;
	@Column(name = "records", comment = "掠夺记录")
	private List<ClanWorldRobRecord> records;
	@Column(name = "battler_vo", comment = "战斗布阵数据", nullable = true)
	private BattlerVo battlerVo;
	@Column(name = "fighting", comment = "阵容战斗力")
	private int fighting;
	@Column(name = "serverId", comment = "服务器ID")
	private int serverId;
	
}
