package com.ayjs.mxzg.gameserver.module.recharge.event;

import lombok.Value;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/15 14:28
 */
@Value(staticConstructor = "of")
public class RechargeEvent {
    private long rid;
    //分
    private int money;
    //商品id,第三方直接购买游戏币商品id为0
    private int productId;
    // 第三方充值购买的游戏币
    private int gameCoin;
}
