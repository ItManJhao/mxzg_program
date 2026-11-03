/**
 * 
 */
package com.ayjs.mxzg.largecross.module.stagematch.pinnacle.domain;

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.module.pinnacle.IPinnacleBattle;

import java.util.Set;


@Entity
@Table(name = "pinnacle_cross_battle", comment = "巅峰赛战斗信息", indexes = {
		@Index(name = "round", columnList = "round") }, cache = { @Cache(columns = "round") })
public class PinnacleCrossBattle extends AbstractEntity implements IPinnacleBattle {
	@Id
    @Column(name = "id", comment = "唯一ID")
    @LongIdGenerate
	private long id;
	@Column(name = "round", comment = "本届巅峰赛的轮数", readOnly = true)
	private int round;
	@Column(name = "period", comment = "比赛阶段，1选拔赛阶段、2淘汰赛阶段")
	private int period;
	@Column(name = "battle_round", comment = "对战轮数")
	private int battleRound;
	@Column(name = "atk_rid", comment = "进攻方玩家ID")
	private long atkRid;
	@Column(name = "def_rid", comment = "防守方玩家ID")
	private long defRid;
	@Column(name = "atk_fight", comment = "进攻方战斗力")
	private int atkFight;
	@Column(name = "def_fight", comment = "防守方战斗力")
	private int defFight;
	@Column(name = "atk_vo", comment = "进攻方战斗信息")
	private BattlerVo atkVo;
	@Column(name = "def_vo", comment = "防守方战斗信息")
	private BattlerVo defVo;
	@Column(name = "battle_id", comment = "战斗ID")
	private String battleId;
	@Column(name = "which_win", comment = "胜负，1进攻方胜，2防守方胜")
	private int whichWin;
	@Column(name = "time", comment = "对战发生的时间")
	private int time;
	@Column(name = "atk_coin", comment = "进攻方当前的竞猜币数量")
	private long atkCoin;
	@Column(name = "def_coin", comment = "防守方当前的竞猜币数量")
	private long defCoin;
	@Column(name = "guess_players", comment = "参与比赛竞猜的玩家")
	private Set<Long> guessPlayers;
	@Column(name = "knockout_sort", comment = "淘汰赛比赛顺序，结合battle_round用于还原服务器重启")
	private int knockoutSort;
	@Column(name = "battle_log", comment = "血量统计的战报", length = 2000)
	private String battleLog;
	@Column(name = "add_point", comment = "胜利方增加的积分")
	private int addPoint;
	@Column(name = "cross_group_id", comment = "跨服分组ID")
	private int crossGroupId;
	
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
	public int getPeriod() {
		return period;
	}
	public void setPeriod(int period) {
		this.period = period;
	}
	public int getBattleRound() {
		return battleRound;
	}
	public void setBattleRound(int battleRound) {
		this.battleRound = battleRound;
	}
	public long getAtkRid() {
		return atkRid;
	}
	public void setAtkRid(long atkRid) {
		this.atkRid = atkRid;
	}
	public long getDefRid() {
		return defRid;
	}
	public void setDefRid(long defRid) {
		this.defRid = defRid;
	}
	public int getAtkFight() {
		return atkFight;
	}
	public void setAtkFight(int atkFight) {
		this.atkFight = atkFight;
	}
	public int getDefFight() {
		return defFight;
	}
	public void setDefFight(int defFight) {
		this.defFight = defFight;
	}
	public BattlerVo getAtkVo() {
		return atkVo;
	}
	public void setAtkVo(BattlerVo atkVo) {
		this.atkVo = atkVo;
	}
	public BattlerVo getDefVo() {
		return defVo;
	}
	public void setDefVo(BattlerVo defVo) {
		this.defVo = defVo;
	}
	public String getBattleId() {
		return battleId;
	}
	public void setBattleId(String battleId) {
		this.battleId = battleId;
	}
	public int getWhichWin() {
		return whichWin;
	}
	public void setWhichWin(int whichWin) {
		this.whichWin = whichWin;
	}
	public int getTime() {
		return time;
	}
	public void setTime(int time) {
		this.time = time;
	}
	public long getAtkCoin() {
		return atkCoin;
	}
	public void setAtkCoin(long atkCoin) {
		this.atkCoin = atkCoin;
	}
	public long getDefCoin() {
		return defCoin;
	}
	public void setDefCoin(long defCoin) {
		this.defCoin = defCoin;
	}
	public Set<Long> getGuessPlayers() {
		return guessPlayers;
	}
	public void setGuessPlayers(Set<Long> guessPlayers) {
		this.guessPlayers = guessPlayers;
	}
	public int getKnockoutSort() {
		return knockoutSort;
	}
	public void setKnockoutSort(int knockoutSort) {
		this.knockoutSort = knockoutSort;
	}
	public String getBattleLog() {
		return battleLog;
	}
	public void setBattleLog(String battleLog) {
		this.battleLog = battleLog;
	}
	public int getAddPoint() {
		return addPoint;
	}
	public void setAddPoint(int addPoint) {
		this.addPoint = addPoint;
	}
	public int getCrossGroupId() {
		return crossGroupId;
	}
	public void setCrossGroupId(int crossGroupId) {
		this.crossGroupId = crossGroupId;
	}
}
