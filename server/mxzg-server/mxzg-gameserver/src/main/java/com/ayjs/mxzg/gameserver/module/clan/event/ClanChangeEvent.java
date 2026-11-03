package com.ayjs.mxzg.gameserver.module.clan.event;

import lombok.Value;

/**
 * 公会改变事件
 *
 * @Author: CWJ
 * @Date: 2019/10/19
 **/
@Value(staticConstructor = "of")
public class ClanChangeEvent {
    private long rid;
    private long newClanId;
    private long oldClanId;
    private boolean isDissolve;//当退出公会时。公会是否解散，true:为解散。false：未解散
}
