/**
 * 
 */
package com.ayjs.mxzg.message.module.clanworldboss;

import java.util.List;

import com.ayjs.mxzg.message.cross.CrossMessage;
import com.ayjs.mxzg.message.cross.PlayerCrossMessage;
import com.ayjs.mxzg.message.cross.RemoteServerMessage;
import com.ayjs.mxzg.message.module.hero.message.HeroMessage.ResHeroMessage;
import com.ayjs.rpc.RemoteMessage;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 *
 */

public class ClanWorldBossMessage {
	//可掠夺的玩家
	@Builder
	@Getter
	@Setter
	public static class CSRobableRole {
		private long rid;					//玩家ID
		private String nick;				//玩家昵称
		private int rank;					//排名
		private long point;					//积分
		private String clanName;			//公会名字
		private int fighting;				//战斗力
		private List<ResHeroMessage> heros;	//布阵英雄
		private int serverId;				//服务器ID
	}
	
	//公会排名数据
	@Builder
	@Getter
	@Setter
	public static class CSClanWorldBossClanRank {
		private long clanId;		//公会ID
		private String clanName;	//公会名字
		private long point;			//积分
		private int rank;			//排名
		private int serverId;		//服务器ID
	}
	
	//玩家排名数据
	@Builder
	@Getter
	@Setter
	public static class CSClanWorldBossRoleRank {
		private long rid;			//玩家ID
		private String nick;		//玩家昵称
		private long point;			//积分
		private int rank;			//排名
		private int serverId;		//服务器ID
	}
	
	//掠夺记录
	@Builder
	@Getter
	@Setter
	public static class CSRobRecord {
		private String battleId;	//战斗ID
		private String nick;		//昵称
		private int strength;		//战斗力
		private int headId;			//头像
		private int borderId;		//头像框
		private int level;			//等级
		private int time;			//时间
		private int type;			//进攻或防守类型，1掠夺，2防守
		private int delta;			//积分变化，0积分不变
		private int win;			//胜利失败，1胜利，2失败
		private long rid;			//玩家ID
		private int serverId;		//服务器ID
	}
	
	//结算活动时的玩家数据
	@Builder
	@Getter
	@Setter
	public static class CSClanMemberRank {
		private long rid;	//玩家ID
		private int rank;	//玩家名次
	}
	
	//结算活动时的 公会数据
	@Builder
	@Getter
	@Setter
	public static class CSClanRank {
		private long clanId;						//公会ID
		private long point;							//积分
		private int rank;							//排名
		private int bossId;							//世界boss配置ID
		private List<CSClanMemberRank> joinMembers;	//参与的玩家
	}
	
	//查看世界BOSS活动数据
	@Builder
	@Getter
	@Setter
	public static class ReqScanClanWorldBossMessage implements PlayerCrossMessage {
		private long rid;
	}
	
	@Builder
	@Getter
	@Setter
	public static class ResScanClanWorldBossMessage implements RemoteMessage {
		private long rid;
		private int roundStartTime;
		private int roundEndTime;
		private int bossId;
		private int nextStageTime;
		private int stage;
		private int challengeCd;
		private int challengeCount;
		private int robCd;
		private int robCount;
		private int hasNewRecord;
	}
	
	//挑战世界BOSS
	@Builder
	@Getter
	@Setter
	public static class ReqChallengeClanWorldBossMessage implements PlayerCrossMessage {
		private long rid;
		//后续看看能不能直接传vo对象
		private String battlerVoJson;
		private int fighting;
	}
	
	@Builder
	@Getter
	@Setter
	public static class ResChallengeClanWorldBossMessage implements RemoteMessage {
		private long rid;
		private byte[] battleReport;
		private int challengeCount;
		private int challengeCd;
		private long point;
		private long damage;
		private long addPoint;
	}
	
	//活动可掠夺列表
	@Builder
	@Getter
	@Setter
	public static class ReqGetRobableRoleMessage implements PlayerCrossMessage {
		private long rid;
	}
	
	@Builder
	@Getter
	@Setter
	public static class ResGetRobableRoleMessage implements RemoteMessage {
		private long rid;
		private List<CSRobableRole> roles;
	}
	
	//掠夺
	@Builder
	@Getter
	@Setter
	public static class ReqRobOtherMessage implements PlayerCrossMessage {
		private long rid;
		//后续看看能不能直接传vo对象
		private String battlerVoJson;
		private int fighting;
		private long targetRid;
	}
	
	@Builder
	@Getter
	@Setter
	public static class ResRobOtherMessage implements RemoteMessage {
		private long rid;
		private int serverId;
		private byte[] battleReport;
		private int robCount;
		private int robCd;
		private long point;
		private long damage;
		private long addPoint;
	}
	
	//查看公会排名
	@Builder
	@Getter
	@Setter
	public static class ReqScanClanRankMessage implements PlayerCrossMessage {
		private long rid;
	}
	
	@Builder
	@Getter
	@Setter
	public static class ResScanClanRankMessage implements RemoteMessage {
		private long rid;
		private CSClanWorldBossClanRank myClan;
		private List<CSClanWorldBossClanRank> ranks;
	}
	
	//查看玩家排名
	@Builder
	@Getter
	@Setter
	public static class ReqScanRoleRankMessage implements PlayerCrossMessage {
		private long rid;
	}
	
	@Builder
	@Getter
	@Setter
	public static class ResScanRoleRankMessage implements RemoteMessage {
		private long rid;
		private CSClanWorldBossRoleRank myRank;
		private List<CSClanWorldBossRoleRank> ranks;
	}
	
	//查看掠夺记录
	@Builder
	@Getter
	@Setter
	public static class ReqScanRobRecordMessage implements PlayerCrossMessage {
		private long rid;
	}
	
	@Builder
	@Getter
	@Setter
	public static class ResScanRobRecordMessage implements RemoteMessage {
		private long rid;
		private List<CSRobRecord> records;
	}
	
	//读取玩家掠夺记录
	@Builder
	@Getter
	@Setter
	public static class ReqReadRobRecordMessage implements PlayerCrossMessage {
		private long rid;
	}
	
	@Builder
	@Getter
	@Setter
	public static class ResReadRobRecordMessage implements RemoteMessage {
		private long rid;
	}
	
	//GM命令转发
	@Builder
	@Getter
	@Setter
	public static class ReqGmCwbChangeStageMessage implements CrossMessage {
	}
	
	//推送目标玩家被略读欧
	@Builder
	@Getter
	@Setter
	public static class ResTellRobMessage implements RemoteServerMessage {
		private long rid;
		private long point;
		private int serverId;
		private byte[] battleReport;
		private int isWin;
		private int atkServerId;
		
		@Override
		public int serverId() {
			return serverId;
		}
	}
	
	//推送活动结束的第一名
	@Builder
	@Getter
	@Setter
	public static class ResTellFirstMessage implements CrossMessage {
		private String fristRole;
		private int firstRoleServer;
		private String firstClan;
		private int firstClanServer;
	}
	
	//推送活动结算发奖励
	@Builder
	@Getter
	@Setter
	public static class ResTellEndMessage implements RemoteServerMessage {
		private int round;
		private int serverId;
		private List<CSClanRank> clans;
		@Override
		public int serverId() {
			return serverId;
		}
	}
	
	//上报发奖结果
	@Builder
	@Getter
	@Setter
	public static class ReqReportCwbRewardMessage implements CrossMessage {
		private int round;
		private int serverId;
	}
	
	//推送活动阶段变化
	@Builder
	@Getter
	@Setter
	public static class ResTellStageChangeMessage implements RemoteMessage {
		private int stage;
		private int nextStageTime;
	}
}
