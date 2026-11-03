package com.ayjs.mxzg.gameserver.module.friend.event;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2019/10/19
 **/
@Value(staticConstructor = "of")
public class FriendGiveEvent {
    private long rid;

    private int giveCount;
}
