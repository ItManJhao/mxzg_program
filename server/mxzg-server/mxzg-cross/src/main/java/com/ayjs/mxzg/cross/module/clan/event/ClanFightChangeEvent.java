package com.ayjs.mxzg.cross.module.clan.event;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2019/12/19
 **/
@Value(staticConstructor = "of")
public class ClanFightChangeEvent {

    private long clanId;

    private long fight;

    private int serverId;
}
