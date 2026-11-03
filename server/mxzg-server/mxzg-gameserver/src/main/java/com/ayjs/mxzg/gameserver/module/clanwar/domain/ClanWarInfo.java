/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.clanwar.domain;

import java.util.Map;
import java.util.Set;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.clanwar.struct.ClanWarBox;

import lombok.Getter;
import lombok.Setter;

/**
 * @author YY 公会战分组数据
 */
@Entity
@Table(name = "clan_war_info", comment = "公会战分组数据")
@Getter
@Setter
public class ClanWarInfo extends AbstractEntity {
	@Id
	@Column(name = "clan_id", comment = "公会ID")
	private long clanId;
	@Column(name = "round", comment = "公会战轮数")
	private int round;
	@Column(name = "box_type", comment = "公会战宝箱类型，胜负宝箱类型")
	private int boxType;
	@Column(name = "box_end_time", comment = "公会战宝箱消失时间")
	private int boxEndTime;
	@Column(name = "box_members", comment = "抽取了公会战宝箱的成员ID集合", length = 3000)
	private Map<Integer, ClanWarBox> boxMember;
	@Column(name = "battle_members", comment = "本轮公会战参战的成员ID集合", length = 1000)
	private Set<Long> battleMembers;
	@Column(name = "cross_round", comment = "公会战跨服轮数")
	private int crossRound;
}
