package com.ayjs.mxzg.gameserver.module.clan.event;

import lombok.Value;

/**
 * 工会捐献
 * @Author: CWJ
 * @Date: 2019/10/19
 **/
@Value(staticConstructor = "of")
public class ClanDonateEvent {
    private long rid;
}
