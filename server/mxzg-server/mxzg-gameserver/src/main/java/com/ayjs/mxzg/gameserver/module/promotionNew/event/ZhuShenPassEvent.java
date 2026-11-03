package com.ayjs.mxzg.gameserver.module.promotionNew.event;

import lombok.Value;

/**
 * 诸神通关事件
 *
 * @Author: CWJ
 * @Date: 2019/10/25
 **/
@Value(staticConstructor = "of")
public class ZhuShenPassEvent {
    private long rid;
    /**
     * 类型
     */
    private int type;

}
