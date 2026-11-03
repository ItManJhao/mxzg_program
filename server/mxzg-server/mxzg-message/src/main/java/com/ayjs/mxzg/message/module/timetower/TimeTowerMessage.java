/**
 * 
 */
package com.ayjs.mxzg.message.module.timetower;

import java.util.List;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import com.ayjs.mxzg.message.largecross.PlayerLargeCrossMessage;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 *
 */
public class TimeTowerMessage {

	@Builder
	@Getter
	@Setter
	public static class CSTimeTowerRank {
		private long rid; 		//玩家ID
		private int serverId;	//服务器ID
		private String name; 	//玩家名字
		private int level;		//玩家等级
		private int headId;		//头像ID
		private int borderId;	//头像框ID
		private int imageId; 	//英雄形象
		private int rank; 		//排名
		private int currLayer;	//当前通关层数
		private int fighting;	//战力
	}
	
	@Builder
	@Getter
	@Setter
	public static class CSTimeTowerReward {
		private long rid; 		//玩家ID
		private int rank;
	}
	
	/**
	 * 查看信息
	 * @author YY
	 *
	 */
	@Builder
	@Getter
	@Setter
	public static class ReqTimeTowerInfoMessage implements PlayerLargeCrossMessage {
		private long rid;
		private int currLayer;
		private int serverId;
	}
	
	@Builder
	@Getter
	@Setter
	public static class ResTimeTowerInfoMessage implements LargeCrossMessage {
		private long rid;
		private int round;
		private int startTime;
		private int endTime;
	}
	
	/**
	 * 过关之后上报数据
	 * @author YY
	 *
	 */
	@Builder
	@Getter
	@Setter
	public static class ReqTimeTowerPassMessage implements PlayerLargeCrossMessage {
		private long rid;
		private int currLayer;
		private int serverId;
		private int fighting;
	}
	
	/**
	 * 请求魔塔排行榜
	 * @author YY
	 *
	 */
	@Builder
	@Getter
	@Setter
	public static class ReqTimeTowerRankMessage implements PlayerLargeCrossMessage {
		private long rid;
		private int serverId;
	}
	
	@Builder
	@Getter
	@Setter
	public static class ResTimeTowerRankMessage implements LargeCrossMessage {
		private long rid;
		private int myRank;
		private List<CSTimeTowerRank> ranks;
	}
	
	/**
	 * 下发赛季奖励
	 * @author YY
	 *
	 */
	@Builder
	@Getter
	@Setter
	public static class ResTimeTowerRewardMessage implements LargeCrossMessage {
		private int round;
		private List<CSTimeTowerReward> rewardRank;
	}
	
	
	/**
	 * 时空魔塔GM发奖
	 * @author YY
	 *
	 */
	@Builder
	@Getter
	@Setter
	public static class ReqTimeTowerGmRewardMessage implements LargeCrossMessage {
		
	}
}
