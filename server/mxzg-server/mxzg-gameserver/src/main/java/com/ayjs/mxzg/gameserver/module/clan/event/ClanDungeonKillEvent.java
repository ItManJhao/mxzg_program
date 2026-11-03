package com.ayjs.mxzg.gameserver.module.clan.event;


import lombok.Value;

/**
 * 公会副本击杀事件
 * @author hyx
 */
@Value(staticConstructor = "of")
public class ClanDungeonKillEvent {

    private long clanId;

    private long rid;

    private int idx;

}
