package com.ayjs.mxzg.gameserver.module.blessingPool.event;

import com.ayjs.mxzg.gameserver.module.blessingPool.constant.BlessingPoolType;
import lombok.Value;

/**
 * 许愿
 *
 * @Author: CWJ
 * @Date: 2019/10/19
 **/
@Value(staticConstructor = "of")
public class BlessingPoolDoneEvent {
    /**
     * 角色id
     */
    private long rid;
    /**
     * 许愿次数
     */
    private int count;
    /**
     * 类型
     */
    private BlessingPoolType type;
}
