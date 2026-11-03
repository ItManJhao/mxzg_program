package com.ayjs.mxzg.message.module.floatingIslands.message;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.Getter;
import lombok.Value;

/**
 * 请求状态信息，跨服连接时
 *
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Getter
@Value(staticConstructor = "of")
public class FloatingIslandsChallengeReqMessage implements LargeCrossMessage {

    /***
     * 玩家id
     */
    private long rid;

    /***
     * 服务器id
     */
    private int serverId;

    /***
     * 本次伤害
     */
    private long dmg;

}
