package com.ayjs.mxzg.gameserver.module.headPortrait.event;

import lombok.Value;

/**
 * 玩家头像改变事件
 * @author  hyx
 */
@Value(staticConstructor = "of")
public class RolePortraitEvent {

    private long rid;

    private int portrait;

}
