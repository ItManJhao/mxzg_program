package com.ayjs.mxzg.tools.client.client;

import lombok.Getter;
import lombok.ToString;

/**
 * 模拟器配置
 *
 * @author tangyangbo 2019/8/6 17:04
 */
@ToString
@Getter
public class ClientCMD {

    public final static String CLIENT_KEY = "client-key";

    public final static int PLAYER_LOGIN_CMD = 1001; // 玩家登录游戏
    public final static int PLAYER_REG_CMD = 1002; // 玩家注册游戏
    public final static int HEART_BEAT = 1004;// 心跳

    public final static int MONSTER_LIST = 1302; // 英雄列表
    public final static int ROLE_INFO = 2001; // 玩家信息
    public final static int CHANGE_NICKNAME = 2003; // 改名
    public final static int ROLE_UPGRADE = 2014; // 玩家升级

    public final static int HERO_LINE_UP_SAVE = 3100;// 上阵保存

    public final static int HERO_LIST = 4001;// 英雄列表
    public final static int HERO_SUMMON = 4002;// 英雄召唤

    public final static int HERO_LEVEL_UP = 4018;// 英雄升级
    public final static int HERO_ONE_KEY_WEAR = 4025;//一键穿戴
    public final static int HERO_ADD = 4030;// 英雄增加推送

    public final static int BACKPACK_GAIN = 5002;// 背包资源推送
    public final static int SEND_CHAT = 6001;// 聊天

    public final static int PVP_DATA = 18001;// 竞技场信息
    public final static int PVP_CHALLENGE = 18002;// 挑战竞技场
    public final static int PVP_REFRESH = 18003;// 竞技场刷新

}
