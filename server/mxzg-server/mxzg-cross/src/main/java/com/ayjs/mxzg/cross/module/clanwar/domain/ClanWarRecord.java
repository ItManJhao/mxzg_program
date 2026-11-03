/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanwar.domain;

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleReport;
import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "clanwar_record", comment = "公会战战斗记录", indexes = {@Index(name = "round", columnList = {"round"})})
@Getter
@Setter
public class ClanWarRecord extends AbstractEntity {
	@Id
	@Column(name = "id", comment = "唯一ID")
	@LongIdGenerate
	private long id;
	@Column(name = "round", comment = "公会战轮数")
	private int round;
	@Column(name = "road", comment = "战斗发生的路号")
	private int road;
	@Column(name = "battle_id", comment = "战斗ID")
	private String battleId;
	@Column(name = "atk_clan_id", comment = "进攻方的公会ID")
	private long atkClanId;
	@Column(name = "def_clan_id", comment = "防守方的公会ID")
	private long defClanId;
	@Column(name = "atk_rid", comment = "进攻方的玩家ID")
	private long atkRid;
	@Column(name = "def_rid", comment = "防守方的玩家ID")
	private long defRid;
	@Column(name = "atk_vo", comment = "进攻方的战斗阵容信息")
	private BattlerVo atkVo;
	@Column(name = "def_vo", comment = "防守方的战斗阵容信息")
	private BattlerVo defVo;
	@Column(name = "which_win", comment = "胜利方，1进攻方，2防守方")
	private int whichWin;
	@Column(name = "time", comment = "战斗时间")
	private int time;
	@Column(name = "atk_fight", comment = "进攻方的战斗力")
	private int atkFight;
	@Column(name = "def_fight", comment = "防守方的战斗力")
	private int defFight;
	
	private BattleReport battleReport;
}
