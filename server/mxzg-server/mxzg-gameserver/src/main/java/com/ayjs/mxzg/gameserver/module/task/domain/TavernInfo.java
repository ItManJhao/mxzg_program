/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.task.domain;

import java.util.Map;
import java.util.Set;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.Table;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "tavern_info", comment = "玩家酒馆数据", indexes = {@Index(name = "rid", columnList = {"rid"})})
public class TavernInfo extends AbstractEntity {
	@Id
	@Column(name = "rid")
	private long rid;
	@Column(name = "first_refresh", comment = "是否是首次刷新")
	private Set<Integer> firstRefreshStars;
	@Column(name = "status", comment = "是否需要配置默认任务，-1为需要，1不需要")
	private int status;
	@Column(name = "daily_time", comment = "每日重置时间")
	private long dailyTime;
	@Column(name = "gem_refresh", comment = "今日刷新次数")
	private int gemRefresh;
	@Column(name = "high_refresh", comment = "今日是否进行过高级刷新，0没有，1刷过")
	private int highRefresh;
	@Column(name = "luxury_refresh", comment = "今日是否进行过豪华刷新，0没有，1刷过")
	private int luxuryRefresh;
	@Column(name = "free_refresh", comment = "已经刷新的免费次数")
	private int freeRefresh;
	@Column(name = "adventure_count", comment = "冒险点数")
    private long adventureCount;
	@Column(name = "refresh_count", comment = "酒馆特殊任务刷新次数记录")
	private Map<Integer, Integer> refreshCount;
	@Column(name = "limit_refresh", comment = "已经刷新的有次数限制的任务")
	private Map<Integer, Integer> limitRefresh;

    public long getAdventureCount() {
        return adventureCount;
    }

    public void setAdventureCount(long adventureCount) {
        this.adventureCount = adventureCount;
    }

    public int getFreeRefresh() {
		return freeRefresh;
	}

	public void setFreeRefresh(int freeRefresh) {
		this.freeRefresh = freeRefresh;
	}

	public long getRid() {
		return rid;
	}
	public void setRid(long rid) {
		this.rid = rid;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public long getDailyTime() {
		return dailyTime;
	}
	public void setDailyTime(long dailyTime) {
		this.dailyTime = dailyTime;
	}
	public int getGemRefresh() {
		return gemRefresh;
	}
	public void setGemRefresh(int gemRefresh) {
		this.gemRefresh = gemRefresh;
	}
	public int getHighRefresh() {
		return highRefresh;
	}
	public void setHighRefresh(int highRefresh) {
		this.highRefresh = highRefresh;
	}
	public int getLuxuryRefresh() {
		return luxuryRefresh;
	}
	public void setLuxuryRefresh(int luxuryRefresh) {
		this.luxuryRefresh = luxuryRefresh;
	}

	/**
	 * 检测并设置星际任务首次刷新
	 * @param star
	 * @return
	 */
	public boolean checkAndSetFirstRefresh(int star) {
		boolean first = !firstRefreshStars.contains(star);
		if(first){
			firstRefreshStars.add(star);
		}
		return first;
	}

	public void addFirstRefreshStar(int star){
		this.firstRefreshStars.add(star);
	}

	public void setFirstRefreshStars(Set<Integer> firstRefreshStars) {
		this.firstRefreshStars = firstRefreshStars;
	}

	public Map<Integer, Integer> getRefreshCount() {
		return refreshCount;
	}

	public void setRefreshCount(Map<Integer, Integer> refreshCount) {
		this.refreshCount = refreshCount;
	}

	public Map<Integer, Integer> getLimitRefresh() {
		return limitRefresh;
	}

	public void setLimitRefresh(Map<Integer, Integer> limitRefresh) {
		this.limitRefresh = limitRefresh;
	}
}
