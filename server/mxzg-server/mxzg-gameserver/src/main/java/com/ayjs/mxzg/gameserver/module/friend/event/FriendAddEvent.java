package com.ayjs.mxzg.gameserver.module.friend.event;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2019/11/14
 **/
@Value(staticConstructor = "of")
public class FriendAddEvent {

    private long rid;
}
