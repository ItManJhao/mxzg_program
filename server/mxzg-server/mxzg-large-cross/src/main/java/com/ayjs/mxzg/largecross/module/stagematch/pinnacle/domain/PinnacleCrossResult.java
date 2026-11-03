/**
 * 
 */
package com.ayjs.mxzg.largecross.module.stagematch.pinnacle.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.struct.PinnacleTopData;

import java.util.List;
import java.util.Map;


@Entity
@Table(name = "pinnacle_cross_result", comment = "巅峰赛结算记录数据", indexes = {
		@Index(name = "idx_server_round", columnList = { "server_id", "round" }) }, cache = {
				@Cache(columns = { "server_id", "round" }) })
public class PinnacleCrossResult extends AbstractEntity {
	@Id
    @Column(name = "id", comment = "唯一ID")
    @LongIdGenerate
	private long id;
	@Column(name = "server_id", comment = "服务器ID", readOnly = true)
	private int serverId;
	@Column(name = "round", comment = "第几届", readOnly = true)
	private int round;
	@Column(name = "tops", comment = "排名前三的数据")
	private List<PinnacleTopData> tops;
	@Column(name = "rank_results", comment = "排名奖励数据")
	private Map<Long, Integer> rankResults;
	@Column(name = "coin_results", comment = "竞猜奖励数据")
	private Map<Long, Long> coinResults;
	@Column(name = "status", comment = "游戏服回报状态，0未回报，1已回报")
	private int status;
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public int getServerId() {
		return serverId;
	}
	public void setServerId(int serverId) {
		this.serverId = serverId;
	}
	public List<PinnacleTopData> getTops() {
		return tops;
	}
	public void setTops(List<PinnacleTopData> tops) {
		this.tops = tops;
	}
	public Map<Long, Integer> getRankResults() {
		return rankResults;
	}
	public void setRankResults(Map<Long, Integer> rankResults) {
		this.rankResults = rankResults;
	}
	public Map<Long, Long> getCoinResults() {
		return coinResults;
	}
	public void setCoinResults(Map<Long, Long> coinResults) {
		this.coinResults = coinResults;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public int getRound() {
		return round;
	}
	public void setRound(int round) {
		this.round = round;
	}
}
