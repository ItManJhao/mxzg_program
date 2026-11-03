package com.ayjs.mxzg.message.module.study;

import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

/**
 * 响应BattleVO查询消息
 */
@Value(staticConstructor = "of")
public class ResBattlerVOMessage implements RemoteMessage {

    /** 战场Vo*/
    private byte[] battlerVo;

    /** 服务器id */
    private int serverId;

    /** 昵称 */
    private String nick;

    /**头像ID */
    private int headId;

    /** 头像框ID */
    private int borderId;

    /** 等级 */
    private int level;

    /** 战力 */
    private int fighting;
}
