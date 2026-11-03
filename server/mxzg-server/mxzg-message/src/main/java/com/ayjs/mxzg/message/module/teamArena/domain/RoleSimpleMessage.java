package com.ayjs.mxzg.message.module.teamArena.domain;

import lombok.Getter;
import lombok.Setter;

/**
 * 玩家形象信息
 *
 * @Author: CWJ
 * te: 2020/4/11
 **/
@Getter
@Setter
public class RoleSimpleMessage {

    private long rid;

    private String roleName;

    private int serverId;

    private int borderId;

    private int headId;

    private int image;

    private int level;

    private long clanId;

    private String clanName;

    private int fighting;
}
