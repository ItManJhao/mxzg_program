/**
 * 
 */
package com.ayjs.mxzg.message.module.clanwar;

import com.ayjs.mxzg.message.cross.CrossMessage;
import com.ayjs.mxzg.message.cross.PlayerCrossMessage;
import com.ayjs.mxzg.message.cross.RemoteServerMessage;
import com.ayjs.mxzg.message.module.hero.message.HeroMessage.ResHeroMessage;
import com.ayjs.rpc.RemoteMessage;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

/**
 * @author YY
 *
 */
public class ClanWarMessage {
	
	//分路的信息
	@Builder
	@Getter
	@Setter
	public static class CSClanWarRoad {
		private int road;		//路号，1左，2中，3右
		private int battling;	//是否在战斗中，0未在战斗中，1在战斗中
		private int total;		//一共多少个队伍
		private int alive;		//存活多少个队伍
	}

	//公会战信息
	@Builder
	@Getter
	@Setter
	public static class CSClanWarInfo {
		private long clanId;			//公会ID
		private String name;			//公会名字
		private int serverId;			//公会所在服务器ID
		private List<CSClanWarRoad> roads;	//分路的信息
	}
	
	
	@Builder
	@Getter
	@Setter
	public static class CSHisBattlePlayer {
		private long rid;					//角色ID
		private String name;				//玩家名字
		private long clanId;				//公会ID
		private List<ResHeroMessage> heros;	//出战英雄
		private int win;					//胜负，0负，1胜
		private int fighting;				//战斗力
	}
	
	@Builder
	@Getter
	@Setter
	public static class CSHisBattleDetail {
		private String battleId;				//战斗ID
		private List<CSHisBattlePlayer> players;//对战双方的玩家
	}
	
	//参战队伍信息
	@Builder
	@Getter
	@Setter
	public static class CSClanWarTeam {
		private long rid;		//玩家ID
		private String name;	//玩家名字
		private int heroType;	//英雄类型
		private int heroLevel;	//英雄等级
		private long fighting;	//战斗力
		private int heroStar;	//英雄星级
		private int fashionId;	//时装ID
		private int evolveType;//进化类型
		private int evolveLevel;//进化等级
	}

	//分路的详细信息
	@Builder
	@Getter
	@Setter
	public static class CSClanWarRoadDetail {
		private int road;			//哪一路
		private List<CSClanWarTeam> teams;	//参战队伍
	}
	
	//分路对战中的队伍信息
	@Builder
	@Getter
	@Setter
	public static class CSClanWarBattling
	{
		private long clanId;				//公会ID
		private List<CSClanWarTeam> teams;	//参战队伍
		private int serverId;				//服务器ID
	}
	
	
	//查看公会战信息
	@Builder
	@Getter
	@Setter
	public static class ReqScanWarInfoMessage implements PlayerCrossMessage {
		private long rid;
	}
	
	@Builder
	@Getter
	@Setter
	public static class ResScanWarInfoMessage implements RemoteMessage {
		private long rid;
		private int roundStartTime;			//本轮活动的开始时间
		private int roundEndTime;			//本轮活动的结束时间
		private List<CSClanWarInfo> warInfos;//对战双方
		private int stage;				//当前阶段，1匹配阶段，2备战阶段，3调整阶段，4开战阶段，5休战阶段
		private int nextStageTime;		//下一阶段的时间
		private int isWin;				//上一轮公会战是否胜利，1胜利，其它失败
		private int canJoin;			//是否可以参与公会战，0不可以，1可以
		private int firstRoundTime;		//第一轮公会战开启的时间
	}
	
	//查看路况信息
	@Builder
	@Getter
	@Setter
	public static class ReqScanRoadInfoMessage implements PlayerCrossMessage {
		private long rid;
	}
	
	@Builder
	@Getter
	@Setter
	public static class ResScanRoadInfoMessage implements RemoteMessage {
		private long rid;
		private List<CSClanWarRoadDetail> details;	//分路详细信息
	}
	
	//保存布阵数据
	@Builder
	@Getter
	@Setter
	public static class ReqSaveRoadFormationMessage implements PlayerCrossMessage {
		private long rid;
		private int road;	//保存哪一路
		private String battlerVoJson;
		private int fighting;
	}
	
	@Builder
	@Getter
	@Setter
	public static class ResSaveRoadFormationMessage implements RemoteMessage {
		private long rid;
		private int road;	//保存哪一路
	}

	//调整队伍出战分路与出战顺序
	@Builder
	@Getter
	@Setter
	public static class ReqAdjustRoadSortMessage implements PlayerCrossMessage {
		private long rid;
		private int road;		//调整到哪一路
		private long targetRid;	//哪个玩家
		private int sort;		//调整到的序号，从1开始
		private int pos;		//当前玩家在公会中的职责
	}
	
	@Builder
	@Getter
	@Setter
	public static class ResAdjustRoadSortMessage implements RemoteMessage {
		private long rid;
		private int road;		//调整到哪一路
		private long targetRid;	//哪个玩家
		private int sort;		//调整到的序号，从1开始
	}

	//查看某一路的当前战况
	@Builder
	@Getter
	@Setter
	public static class ReqScanBattlingInfoMessage implements PlayerCrossMessage {
		private long rid;
		private int road;	//哪一路
	}
	
	@Builder
	@Getter
	@Setter
	public static class ResScanBattlingInfoMessage implements RemoteMessage {	
		private long rid;
		private List<CSClanWarBattling> battling;	//双方对战信息
		private CSHisBattleDetail detail;			//当前正在进行的战斗详细信息
	}

	//查看某一路的历史战况
	@Builder
	@Getter
	@Setter
	public static class ReqScanHisBattlingInfoMessage implements PlayerCrossMessage {
		private long rid;
		private int road;	//哪一路
	}

	@Builder
	@Getter
	@Setter
	public static class ResScanHisBattlingInfoMessage implements RemoteMessage {
		private long rid;
		private List<CSHisBattleDetail> hisInfo;	//简要信息
	}

	//战场有变化时推送
	public static class ResWarBattleNext {
	}

	//查看某个公会成员的布路信息
	@Builder
	@Getter
	@Setter
	public static class ReqScanMemberRoadInfoMessage implements PlayerCrossMessage {
		private long rid;
		private long targetRid;
	}
	
	@Builder
	@Getter
	@Setter
	public static class ResScanMemberRoadInfoMessage implements RemoteMessage {
		private long rid;
		private long playerId;		// 玩家的rid
		private int fighting;		// 战斗力
		private List<ResHeroMessage> heroData; // 上阵英雄的信息
	}
	
	//gm改公会战阶段
	@Builder
	@Getter
	@Setter
	public static class ReqGmClanWarChangeStageMessage implements CrossMessage {
		
	}
	
	//查询公会的阶段信息与参战公会信息
	@Builder
	@Getter
	@Setter
	public static class ReqClanWarStageMessage implements CrossMessage {
		private int serverId;
	}
	
	//在子服连接上跨服时，或者跨服上的公会战完成公会匹配之后会下发此消息
	@Builder
	@Getter
	@Setter
	public static class ResClanWarStageMessage implements RemoteServerMessage {
		private int serverId;
		private int roundEndTime;		//本轮公会战结束时间
		private List<Long> battleClans;	//参战的公会
		@Override
		public int serverId() {
			return serverId;
		}
	}
	
	//推送公会战结束
	@Builder
	@Getter
	@Setter
	public static class ResClanWarTellEndMessage implements RemoteServerMessage {
		private int serverId;
		private long clanId;	//公会ID
		private int isWin;		//1胜利，2失败
		private List<Long> battleMembers;	//参战成员
		private int round;
		@Override
		public int serverId() {
			return serverId;
		}
	}
	
	//游戏服上报公会已发奖状态
	@Builder
	@Getter
	@Setter
	public static class ReqClanWarReportRewardMessage implements CrossMessage {
		private int round;
		private long clanId;
	}
	
	//推送游戏服公会战阶段变化
	@Builder
	@Getter
	@Setter
	public static class ResClanWarTellStageMessage implements RemoteServerMessage {
		private int serverId;			//服务器ID
		private int stage;				//当前阶段
		private List<Long> clanIds;		//公会ID
		private int roundEndTime;		//本轮的结束时间
		@Override
		public int serverId() {
			return serverId;
		}
	}
	
	//推送游戏服公会战发生战斗
	@Builder
	@Getter
	@Setter
	public static class ResClanWarTellBattleHappenMessage implements RemoteServerMessage {
		private int serverId;			//服务器ID
		private List<Long> clanIds;		//公会ID
		@Override
		public int serverId() {
			return serverId;
		}
	}
	
	@Builder
	@Getter
	@Setter
	public static class ResClanWarSaveBattleMessage implements RemoteServerMessage {
		private int serverId;			//服务器ID
		private long clanId;			//公会ID
		private List<byte[]> battleReports;	//战报
		@Override
		public int serverId() {
			return serverId;
		}
	}
}
