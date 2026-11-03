package com.ayjs.mxzg.gameserver.module.clan.event;

import lombok.Value;

/**
 * 公会战力改变事件
 *
 * @Author: CWJ
 * @Date: 2019/12/19
 **/
@Value(staticConstructor = "of")
public class ClanFightingUpdateEvent {

    private long clanId;

    private long fighting;

    private boolean dissolve;

}
