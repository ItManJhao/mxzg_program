package com.ayjs.mxzg.gameserver.module.buygold.event;

import com.ayjs.mxzg.gameserver.module.buygold.constant.BuyGoldType;
import lombok.Value;

/**
 * 点金购买事件
 *
 * @Author: CWJ
 * @Date: 2019/10/19
 **/
@Value(staticConstructor = "of")
public class BuyGoldEvent {
    /**
     * 角色Id
     */
    private long rid;
    /**
     * 购买类型
     */
    private BuyGoldType type;
}
