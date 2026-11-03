/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanworldboss.domain;

import java.util.Map;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;

import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "clanworldboss_result", comment = "公会世界BOSS结算信息")
@Getter
@Setter
public class ClanWorldBossResult extends AbstractEntity {
	@Id
	@LongIdGenerate
	@Column(name = "id", comment = "唯一ID")
	private long id;
	@Column(name = "round", comment = "轮数")
	private int round;
	@Column(name = "group_id", comment = "跨服分组")
	private int groupId;
	@Column(name = "clan_id", comment = "公会ID")
	private long clanId;
	@Column(name = "clan_name", comment = "公会名字")
	private String clanName;
	@Column(name = "point", comment = "积分")
	private long point;
	@Column(name = "rank", comment = "排名")
	private int rank;
	@Column(name = "join_members", comment = "参与的成员")
	private Map<Long, Integer> joinMembers;
	@Column(name = "boss_id", comment = "boss配置ID")
	private int bossId;
	@Column(name = "status", comment = "游戏服回报的发奖状态，0未回报，1已回报，用于对未回报的服务器进行奖励补发")
	private int status;
	@Column(name = "server_id", comment = "服务器ID")
	private int serverId;
}