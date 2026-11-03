package com.ayjs.mxzg.gameserver.web.event;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2019/11/4
 **/
@Value(staticConstructor = "of")
public class ServerOpenTimeResetEvent {
    private int serverTime;
}
