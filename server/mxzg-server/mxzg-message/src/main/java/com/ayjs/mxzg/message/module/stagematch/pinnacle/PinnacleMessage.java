/**
 * 
 */
package com.ayjs.mxzg.message.module.stagematch.pinnacle;

import com.ayjs.mxzg.message.cross.RemoteServerMessage;
import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import com.ayjs.mxzg.message.largecross.PlayerLargeCrossMessage;
import com.ayjs.rpc.RemoteMessage;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;


public class PinnacleMessage {


	@Builder
	@Getter
	@Setter
	public static class CSPinnacleBiu {
		private String content; // 内容
		private long rid; // 玩家ID
	}

	@Builder
	@Getter
	@Setter
	public static class CSPinnacleRank {
		private long rid; // 玩家ID
		private String name; // 玩家名字
		private int like; // 点赞数
		private int imageId; // 英雄形象
		private int rank; // 排名
		private int robot; // 是否机器人，0不是，1是
	}

	@Builder
	@Getter
	@Setter
	public static class CSPinnacleRanker {
		private long rid; // 玩家ID
		private String name; // 玩家名字
		private int like; // 点赞数
		private int rank; // 排名
		private int level; //
		private int headId; //
		private int borderId; //
		private int point; // 选拔赛分数
		private int fighting; // 战斗力
		private int robot; // 是否机器人，0不是，1是
		private int serverId;//服务器ID
		private int imageId;	//形象id
		private int stageId;	//段位id
	}

	@Builder
	@Getter
	@Setter
	public static class CSPinnacleHero {
		private int heroType; // 英雄类型
		private int level; // 等级
		private int stage; // 阶级
		private int star; // 星级
		private int pos; // 站位，前端排序
		private long id; // 英雄ID
		private int fashionId; // 皮肤（时装）id
	}

	@Builder
	@Getter
	@Setter
	public static class CSPinnacleFormation {
		private long rid; // 参赛者ID，玩家ID或者机器人ID
		private String name; // 名字
		private int level; // 角色等级
		private int headId; // 头像
		private int borderId; // 头像框
		private int fighting; // 战斗力
		private List<CSPinnacleHero> heros; // 参战英雄
		private int robot; // 是否机器人，0玩家，1机器人
		private int formationId;//阵法ID
	}

	@Builder
	@Getter
	@Setter
	public static class CSPinnacleKnockoutBattle {
		private String atkName;
		private String defName;
		private long bid; // 比赛ID
		private int battleRound;// 比赛所属的战斗阶段，32、16、8、4、2
		private int whichWin; // 胜利方，1进攻方胜利，2防守方胜利
		private String battleId;// 战斗ID
		private int winHead;
		private int winBorder;
		private long atkRid; // 进攻方ID
		private long defRid; // 防守方ID
	}

	@Builder
	@Getter
	@Setter
	public static class CSPinnacleGuess {
		private long bid; // 比赛ID
		private String battleId; // 战斗ID
		private int guessType; // 竞猜哪一边胜利，1进攻方，2防守方
		private long guessCoin; // 玩家投注的竞猜币
		private long delta; // 战斗结算后竞猜币的变化量
		private CSPinnacleFormation attacker;// 进攻方
		private CSPinnacleFormation defender;// 防守方
		private int period; // 巅峰赛当前赛程，0空闲，1选拔赛，2淘汰赛
		private int battleRound; // 比赛所属的战斗阶段，32、16、8、4、2
		private int whichWin; // 胜利方，1进攻方胜利，2防守方胜利，0未有胜负
		private String battleLog; // 血量统计
	}

	@Builder
	@Getter
	@Setter
	public static class CSPinnacleBattle {
		private long bid; // 比赛ID
		private String battleId; // 战斗ID
		private int addPoint; // 胜利方增加的积分，需要结合which_win来处理正负
		private CSPinnacleFormation attacker; // 进攻方
		private CSPinnacleFormation defender; // 防守方
		private int whichWin; // 胜利方，1进攻方胜利，2防守方胜利，0未有胜负
		private int period; // 巅峰赛当前赛程，0空闲，1选拔赛，2淘汰赛
		private int battleRound; // 比赛所属的战斗阶段，32、16、8、4、2
		private String battleLog; // 血量统计
	}

	@Builder
	@Getter
	@Setter
	public static class CSPinnacleMyResult {
		private int rank; // 名次
		private int battleNum; // 战斗场数
		private int winNum; // 胜利场数
	}
	
	@Builder
	@Getter
	@Setter
	public static class CSPinnacleTop {
		private long rid;
		private int rank;
		private int robot;
	}
	
	
	@Builder
	@Getter
	@Setter
	public static class CSPinnacleRankResult {
		private long rid;
		private int rank;
	}
	
	@Builder
	@Getter
	@Setter
	public static class CSPinnacleCoinResult {
		private long rid;
		private long coinNum;
	}

	@Builder
	@Getter
	@Setter
	public static class CSPinnacleGuessWinner {
		private long rid;
		private long gainCoin;
	}


	/**
	 * 开启巅峰赛
	 */
	@Builder
	@Getter
	@Setter
	public static class PinnacleOpenMessage implements RemoteMessage {
	}

	/**
	 * 查看信息
	 */
	@Builder
	@Getter
	@Setter
	public static class ReqScanPinnacleMessage implements PlayerLargeCrossMessage {
		private long rid;
	}

	@Builder
	@Getter
	@Setter
	public static class ResScanPinnacleMessage implements RemoteMessage {
		private long rid;
		private int like; // 我的被点赞次数
		private int period; // 巅峰赛当前赛程，0空闲，1选拔赛，2淘汰赛
		private int rank; // 我的当前排名，0未上榜
		private int hisRank; // 我的历史最高排名
		private int startTime; // 赛季开始时间
		private int endTime; // 赛季结束时间
		private List<CSPinnacleRank> ranks; // 前3排名
		private List<Long> likeRank; // 已经点赞的玩家
		private int biuCd; // 弹幕冷却时间
		private int showRound; // 是否需要请求展示最新一期巅峰赛冠军界面，0不需要，1需要
		private CSPinnacleMyResult result;// 我的最新一期成绩信息，为空时不展示
		private int battleStartTime; // 本届比赛战斗开始时间
		private int battleRound;	//当前的战斗回合
	}

	/**
	 * 查看我的竞赛信息
	 *
	 */
	@Builder
	@Getter
	@Setter
	public static class ReqMyPinnacleBattle implements PlayerLargeCrossMessage {
		private long rid;
	}

	@Builder
	@Getter
	@Setter
	public static class ResMyPinnacleBattle implements RemoteMessage {
		private long rid;
		private int period; // 当前赛程，1选拔赛，2淘汰赛
		private int battleRound; // 当前的战斗回合
		private int nextTime; // 下一阶段的时间
		private CSPinnacleFormation attacker; // 进攻方
		private CSPinnacleFormation defender; // 防守方
		private long bid; // 比赛ID，通过此ID查询战斗ID，再进行战斗回放，为0没有战斗
		private String battleId; // 战斗ID，已经战斗过的比赛才有战斗ID，当在界面中等待倒计时需要用比赛ID进行查询再进行回放，注意判断空
		private int whichWin; // 哪边胜利，1进攻方胜利，2防守方胜利，0未有胜负结果
		private int stage; // 比赛阶段，0匹配、1准备、2竞猜、3战斗
	}

	/**
	 * 查看竞猜的比赛信息
	 *
	 */
	@Builder
	@Getter
	@Setter
	public static class ReqGuessPinnacleBattle implements PlayerLargeCrossMessage {
		private long rid;
		private int serverId;
	}

	@Builder
	@Getter
	@Setter
	public static class ResGuessPinnacleBattle implements RemoteMessage {
		private long rid;
		private int period; // 当前赛程，1选拔赛，2淘汰赛
		private int battleRound; // 当前的战斗回合
		private int nextTime; // 下一阶段的时间
		private CSPinnacleFormation attacker; // 进攻方
		private CSPinnacleFormation defender; // 防守方
		private long guessCoin; // 我的竞猜币数量
		private long atkCoin; // 进攻方当前的竞猜币数量
		private long defCoin; // 防守方当前的竞猜币数量
		private int isGuess; // 是否已经参与本场竞猜，0未参与，1已参与
		private long bid; // 比赛ID，通过此ID查询战斗ID，再进行战斗回放
		private int whichWin; // 哪边胜利，1进攻方胜利，2防守方胜利，0未有胜负结果
		private String battleId; // 战斗ID
		private int stage; // 比赛阶段，0匹配、1准备、2竞猜、3战斗
		private int guessType; // 竞猜哪一边胜利，1进攻方，2防守方，先判断is_guess
	}

	/**
	 * 比赛竞猜
	 */
	@Builder
	@Getter
	@Setter
	public static class ReqPinnacleGuessOneBattle implements PlayerLargeCrossMessage {
		private long rid;
		private int type; // 竞猜哪一边胜利，1进攻方，2防守方
		private long guessCoin; // 投注竞猜币数量
	}

	@Builder
	@Getter
	@Setter
	public static class ResPinnacleGuessOneBattle implements RemoteMessage {
		private long rid;
		private long guessCoin; // 玩家剩余的竞猜币
	}

	/**
	 * 通过比赛ID查询战斗ID
	 */
	@Builder
	@Getter
	@Setter
	public static class ReqGetPinnacleBattle implements PlayerLargeCrossMessage {
		private long rid;
		private long bid;
	}

	@Builder
	@Getter
	@Setter
	public static class ResGetPinnacleBattle implements RemoteMessage {
		private long rid;
		private String battleId;
	}

	/**
	 * 查看巅峰赛32强信息
	 */
	@Builder
	@Getter
	@Setter
	public static class ReqScanPinnacleKnockout implements PlayerLargeCrossMessage {
		private long rid;
		private long serverId;
	}

	@Builder
	@Getter
	@Setter
	public static class ResScanPinnacleKnockout implements RemoteMessage {
		private long rid;
		private long guessId; // 正在进行竞猜的比赛ID
		private int battleRound; // 比赛轮次，32、16、8、4、2
		private int nextTime; // 下一阶段的时间
		private List<CSPinnacleKnockoutBattle> battles; // 比赛列表
		private int stage; // 比赛阶段，0匹配、1准备、2竞猜、3战斗
	}

	/**
	 * 排行榜点赞
	 *
	 */
	@Builder
	@Getter
	@Setter
	public static class ReqPinnacleLike implements PlayerLargeCrossMessage {
		private long rid;
		private long targetRid; // 点赞的角色ID
	}

	@Builder
	@Getter
	@Setter
	public static class ResPinnacleLike implements RemoteMessage {
		private long rid;
		private long targetRid; // 点赞的角色ID
	}

	/**
	 * 巅峰赛发弹幕
	 *
	 */
	@Builder
	@Getter
	@Setter
	public static class ReqPinnacleBiubiu implements PlayerLargeCrossMessage {
		private long rid;
		private String content;
		private int biuCd;
	}

	@Builder
	@Getter
	@Setter
	public static class ResPinnacleBiubiu implements RemoteMessage {
		private long rid;
		private int biuCd; // 发弹幕冷却时间
	}

	/**
	 * 请求弹幕列表
	 *
	 */
	@Builder
	@Getter
	@Setter
	public static class ReqPinnacleBiuList implements PlayerLargeCrossMessage {
		private long rid;
	}

	@Builder
	@Getter
	@Setter
	public static class ResPinnacleBiuList implements RemoteMessage {
		private long rid;
		private List<CSPinnacleBiu> content; // 弹幕列表
	}

	/**
	 * 有新弹幕时候的推送
	 *
	 */
	@Builder
	@Getter
	@Setter
	public static class ResPinnacleBiuChange implements LargeCrossMessage {
		private CSPinnacleBiu content; // 新的弹幕内容
	}

	/**
	 * 玩家的竞猜列表
	 *
	 */
	@Builder
	@Getter
	@Setter
	public static class ReqPinnacleGuessList implements PlayerLargeCrossMessage {
		private long rid;
	}

	@Builder
	@Getter
	@Setter
	public static class ResPinnacleGuessList implements RemoteMessage {
		private long rid;
		private List<CSPinnacleGuess> record; // 竞猜记录
	}

	/**
	 * 竞猜比赛中奖推送
	 *
	 */
	@Builder
	@Getter
	@Setter
	public static class ResPinnacleGuessWin implements RemoteServerMessage {
		private int serverId;	//服务器ID
		private int period; // 比赛进程
		private int battleRound; // 比赛回合
		private List<CSPinnacleGuessWinner> guessWinners;	//竞猜中奖的玩家
		@Override
		public int serverId() {
			return serverId;
		}
	}

	/**
	 * 请求我的比赛列表
	 *
	 */
	@Builder
	@Getter
	@Setter
	public static class ReqScanMyPinnacleBattle implements PlayerLargeCrossMessage {
		private long rid;
	}

	@Builder
	@Getter
	@Setter
	public static class ResScanMyPinnacleBattle implements RemoteMessage {
		private long rid;
		private List<CSPinnacleBattle> battles; // 比赛列表
	}

	/**
	 * 巅峰赛阶段变化的推送
	 *
	 */
	@Builder
	@Getter
	@Setter
	public static class ResPinnacleStageChange implements RemoteMessage {
	}

	/**
	 * 巅峰赛排行榜
	 *
	 */
	@Builder
	@Getter
	@Setter
	public static class ReqPinnacleRank implements PlayerLargeCrossMessage {
		private long rid;
	}

	@Builder
	@Getter
	@Setter
	public static class ResPinnacleRank implements RemoteMessage {
		private long rid;
		private List<CSPinnacleRanker> ranks; // 排行榜数据
	}

	/**
	 * 推送巅峰赛结束
	 */
	@Builder
	@Getter
	@Setter
	public static class ResPinnacleEnd implements RemoteServerMessage {
		private int serverId;
		private int round;
		private List<CSPinnacleTop> topRanks;	//前三的数据
		private List<CSPinnacleRankResult> rankResult;	//排名结果
		private List<CSPinnacleCoinResult> coinResult;	//竞猜结果
		@Override
		public int serverId() {
			return serverId;
		}
	}

	/**
	 * 请求最新一期巅峰赛冠军信息
	 *
	 */
	@Builder
	@Getter
	@Setter
	public static class ReqPinnacleShowTop implements PlayerLargeCrossMessage {
		private long rid;
	}

	@Builder
	@Getter
	@Setter
	public static class ResPinnacleShowTop implements RemoteMessage {
		private long rid;
		private List<CSPinnacleRanker> ranks; // 排行榜数据
		private int time; // 比赛时间
	}

	/**
	 * 标记已经展示过玩家的最新一期比赛结果
	 */
	@Builder
	@Getter
	@Setter
	public static class ReqPinnacleShowMyResult implements PlayerLargeCrossMessage {
		private long rid;
	}

	@Builder
	@Getter
	@Setter
	public static class ResPinnacleShowMyResult implements RemoteMessage {
		private long rid;
	}

	/**
	 * 竞猜投注广播
	 *
	 */
	@Builder
	@Getter
	@Setter
	public static class ResPinnacleGuessBroadcast implements LargeCrossMessage {
		private int type; // 竞猜哪一边胜利，1进攻方，2防守方
		private long guessCoin; // 投注竞猜币数量
	}

	/**
	 * 巅峰赛保存阵容后发送
	 *
	 */
	@Builder
	@Getter
	@Setter
	public static class ReqPinnacleSaveFormation implements PlayerLargeCrossMessage {
		private long rid;
		private byte[] battlerVo;
		private int fighting;
	}

	@Builder
	@Getter
	@Setter
	public static class ResPinnacleSaveFormation implements RemoteMessage {
		private long rid;
	}

	/**
	 * 某个战斗阵容发生改变时推送，推送给对战的双方
	 *
	 */
	@Builder
	@Getter
	@Setter
	public static class ResPinnacleFormationChange implements LargeCrossMessage {
	}

	@Builder
	@Getter
	@Setter
	public static class ResPinnacleSaveBattle implements RemoteServerMessage {
		private int serverId;
		private List<byte[]> battleReports;	//战报
		@Override
		public int serverId() {
			return serverId;
		}
	}
	
	@Builder
	@Getter
	@Setter
	public static class ReqPinnacleReport implements LargeCrossMessage {
		private int serverId;
		private int round;
	}
	
	@Builder
	@Getter
	@Setter
	public static class ReqPinnacleCrossGmNextStage implements LargeCrossMessage {
	}
	
	/**
	 * 清除弹幕
	 *
	 */
	@Builder
	@Getter
	@Setter
	public static class ResPinnacleCrossCleanBiu implements RemoteMessage {
	}

	@Builder
	@Getter
	@Setter
	public static class ReqResetStage implements LargeCrossMessage {
	}
}
