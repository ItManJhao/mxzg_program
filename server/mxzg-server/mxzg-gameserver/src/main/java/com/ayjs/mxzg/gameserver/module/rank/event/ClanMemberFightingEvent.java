package com.ayjs.mxzg.gameserver.module.rank.event;

import lombok.Value;

@Value(staticConstructor = "of")
public class ClanMemberFightingEvent {
    private long clanId;
}
