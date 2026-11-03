/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanworldboss.struct;

import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 *
 */
@Getter
@Setter
public class ClanWorldRobRecord {
	private String battleId;//战斗ID
	private String nick;	//昵称
	private int strength;	//战斗力
	private int headId;		//头像
	private int borderId;	//头像框
	private int level;		//等级
	private int time;		//时间
	private int type;		//进攻或防守类型，1掠夺，2防守
	private int delta;		//积分变化，0积分不变
	private int win;		//胜利失败，1胜利，2失败
	private int read;		//是否已读，0未读，1已读
	private long rid;		//玩家ID
	private int serverId;	//服务器ID
}
