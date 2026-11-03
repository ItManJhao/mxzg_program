package com.ayjs.mxzg.gameserver.module.clan.event;

import com.ayjs.mxzg.config.struct.ClanJobEnum;

import lombok.Value;

/**
 * 公会成员职位变动事件
 * @author hyx
 */
@Value(staticConstructor = "of")
public class ClanJobChangeEvent {

    private long clanId;

    private long rid;

    private long memberId;

    private ClanJobEnum oldJob;

    private ClanJobEnum newJob;

    private int time;

}
