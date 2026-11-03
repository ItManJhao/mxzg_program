/**
 *
 */
package com.ayjs.mxzg.gameserver.module.battle.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "role_mission", comment = "角色关卡表")
public class RoleMission extends AbstractEntity {
	@Id
	@Column(name = "rid", comment = "角色ID")
	private long rid;
	@Column(name = "chapter_id", comment = "关卡奖励表的主键id")
	private int chapterId;
    @Column(name = "start_time", comment = "资源挂机开始时间")
	private int startTime;
	@Column(name = "quick_battle_time", comment = "快速战斗时间")
	private int quickBattleTime;
	@Column(name = "quick_num", comment = "已快速战斗次数")
	private int quickNum;
    @Column(name = "chapter_reward", comment = "关卡奖励领取", length = 512)
	private List<Integer> chapterReward;
	@Column(name = "chapter_reward_id", comment = "新的领取过奖励的关卡id", length = 512)
	private List<Integer> chapterRewardId;
    @Column(name = "receive_reward", comment = "是否有奖励可领取")
    private boolean receiveReward;
    @Column(name = "reward_id", comment = "已经领取到的关卡额外奖励id")
    private List<Integer> rewardIds = new ArrayList<>();
//	@Column(name = "refresh_time", comment = "掉落周期刷新时间")
//	private int refreshTime;
	// key 类型1钻石,2进阶石,3符文,4碎片,5装备
	@Column(name = "drop_data", comment = "掉落周期数据", length = 512)
	private Map<Integer, DropData> dropData;
	@Column(name = "drop_reward_time",comment = "挂机掉落领取时间")
	private int dropRewardTime;
	@Column(name = "mission_rank_time",comment = "排行榜时间")
	private int missionRankTime;

	public long getRid() {
		return rid;
	}

	public void setRid(long rid) {
		this.rid = rid;
	}

	public int getStartTime() {
		return startTime;
	}

	public void setStartTime(int startTime) {
		this.startTime = startTime;
	}

	public int getQuickNum() {
		return quickNum;
	}

	public void setQuickNum(int quickNum) {
		this.quickNum = quickNum;
	}

	public int getQuickBattleTime() {
		return quickBattleTime;
	}

	public void setQuickBattleTime(int quickBattleTime) {
		this.quickBattleTime = quickBattleTime;
	}

	public List<Integer> getChapterReward() {
		return chapterReward;
	}

    public void setChapterReward(List<Integer> chapterReward) {
		this.chapterReward = chapterReward;
	}

	public int getChapterId() {
		return chapterId;
	}

	public void setChapterId(int chapterId) {
		this.chapterId = chapterId;
	}

	public boolean isReceiveReward() {
		return receiveReward;
	}

	public void setReceiveReward(boolean receiveReward) {
		this.receiveReward = receiveReward;
	}

	public List<Integer> getRewardIds() {
		return rewardIds;
	}

	public void setRewardIds(List<Integer> rewardIds) {
		this.rewardIds = rewardIds;
	}

	public List<Integer> getChapterRewardId() {
		return chapterRewardId;
	}

	public void setChapterRewardId(List<Integer> chapterRewardId) {
		this.chapterRewardId = chapterRewardId;
	}

	public Map<Integer, DropData> getDropData() {
		return dropData;
	}

	public void setDropData(Map<Integer, DropData> dropData) {
		this.dropData = dropData;
	}

	public int getDropRewardTime() {
		return dropRewardTime;
	}

	public void setDropRewardTime(int dropRewardTime) {
		this.dropRewardTime = dropRewardTime;
	}

	public int getMissionRankTime() {
		return missionRankTime;
	}

	public void setMissionRankTime(int missionRankTime) {
		this.missionRankTime = missionRankTime;
	}

//	public int getRefreshTime() {
//		return refreshTime;
//	}
//
//	public void setRefreshTime(int refreshTime) {
//		this.refreshTime = refreshTime;
//	}
}
