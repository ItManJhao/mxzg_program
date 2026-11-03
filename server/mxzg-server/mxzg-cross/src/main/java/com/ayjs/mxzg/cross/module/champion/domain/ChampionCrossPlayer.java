/**
 * 
 */
package com.ayjs.mxzg.cross.module.champion.domain;

import java.util.List;
import java.util.Set;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.config.struct.champion.ChampionGuess;
import com.ayjs.mxzg.config.struct.champion.ChampionResult;
import com.ayjs.mxzg.module.champion.IChampionPlayer;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "champion_cross_player", comment = "跨服冠军赛玩家信息", indexes = {
		@Index(name = "round", columnList = { "round" }) })
public class ChampionCrossPlayer extends AbstractEntity implements IChampionPlayer {
	@Id
    @Column(name = "rid", comment = "玩家ID")
	private long rid;
	@Column(name = "biu_cd", comment = "弹幕冷却时间")
	private int biuCd;
	@Column(name = "his_rank", comment = "历史最高排行")
	private int hisRank;
	@Column(name = "like", comment = "历史收获点赞次数")
	private int like;
	@Column(name = "daily_time", comment = "每日重置时间")
	private int dailyTime;
	@Column(name = "kneel", comment = "今天已膜拜的玩家", length = 200)
	private Set<Long> kneels;
	
	@Column(name = "round", comment = "冠军赛轮数")
	private int round;
	@Column(name = "guess_id", comment = "当前正在竞猜的比赛ID")
	private long guessId;
	@Column(name = "guess_coin", comment = "竞猜币数量")
	private long guessCoin;
	@Column(name = "guess_type", comment = "竞猜类型，1进攻方胜利，2防守方胜利")
	private int guessType;
	@Column(name = "bet_coin", comment = "投注竞猜币数量")
	private long betCoin;
	@Column(name = "guess_record", comment = "本届冠军赛竞猜记录")
	private List<ChampionGuess> guessRecords;
	
	@Column(name = "show_round", comment = "已展示的冠军赛轮数，用于前端弹出冠军赛结算界面，0未展示，1已展示")
	private int showRound;
	@Column(name = "result", comment = "最新一期的个人成绩")
	private ChampionResult result;
	@Column(name = "show_result", comment = "是否已经展示最新一期的个人成绩，0未展示，1已展示")
	private int showResult;
	
	
	
	public long getRid() {
		return rid;
	}
	public void setRid(long rid) {
		this.rid = rid;
	}
	public int getRound() {
		return round;
	}
	public void setRound(int round) {
		this.round = round;
	}
	public long getGuessId() {
		return guessId;
	}
	public void setGuessId(long guessId) {
		this.guessId = guessId;
	}
	public long getGuessCoin() {
		return guessCoin;
	}
	public void setGuessCoin(long guessCoin) {
		this.guessCoin = guessCoin;
	}
	public int getGuessType() {
		return guessType;
	}
	public void setGuessType(int guessType) {
		this.guessType = guessType;
	}
	public long getBetCoin() {
		return betCoin;
	}
	public void setBetCoin(long betCoin) {
		this.betCoin = betCoin;
	}
	public List<ChampionGuess> getGuessRecords() {
		return guessRecords;
	}
	public void setGuessRecords(List<ChampionGuess> guessRecords) {
		this.guessRecords = guessRecords;
	}
	public int getShowRound() {
		return showRound;
	}
	public void setShowRound(int showRound) {
		this.showRound = showRound;
	}
	public ChampionResult getResult() {
		return result;
	}
	public void setResult(ChampionResult result) {
		this.result = result;
	}
	public int getShowResult() {
		return showResult;
	}
	public void setShowResult(int showResult) {
		this.showResult = showResult;
	}
	public int getBiuCd() {
		return biuCd;
	}
	public void setBiuCd(int biuCd) {
		this.biuCd = biuCd;
	}
	public int getHisRank() {
		return hisRank;
	}
	public void setHisRank(int hisRank) {
		this.hisRank = hisRank;
	}
	public int getLike() {
		return like;
	}
	public void setLike(int like) {
		this.like = like;
	}
	public int getDailyTime() {
		return dailyTime;
	}
	public void setDailyTime(int dailyTime) {
		this.dailyTime = dailyTime;
	}
	public Set<Long> getKneels() {
		return kneels;
	}
	public void setKneels(Set<Long> kneels) {
		this.kneels = kneels;
	}
}
