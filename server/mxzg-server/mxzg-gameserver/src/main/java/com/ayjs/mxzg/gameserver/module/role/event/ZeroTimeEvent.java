package com.ayjs.mxzg.gameserver.module.role.event;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2019/10/22
 **/
@Value(staticConstructor = "of")
public class ZeroTimeEvent {
    private long rid;
}
