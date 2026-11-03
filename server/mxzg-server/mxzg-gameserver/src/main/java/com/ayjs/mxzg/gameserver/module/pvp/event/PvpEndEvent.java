package com.ayjs.mxzg.gameserver.module.pvp.event;

import lombok.Value;

/**
 * pvp结束
 *
 * @Author: CWJ
 * @Date: 2019/10/21
 **/
@Value(staticConstructor = "of")
public class PvpEndEvent {
    private long rid;
    private boolean win;
    private int score;
}
