package com.ayjs.mxzg.gameserver.module.clan.event;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2019/10/19
 **/
@Value(staticConstructor = "of")
public class ClanDungeonChallengeEvent {
    private long rid;
}
