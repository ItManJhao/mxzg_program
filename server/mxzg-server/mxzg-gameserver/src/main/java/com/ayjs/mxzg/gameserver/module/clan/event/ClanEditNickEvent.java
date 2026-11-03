package com.ayjs.mxzg.gameserver.module.clan.event;

import lombok.Value;

/**
 * @author LY
 * @date 2020/9/1 20:14
 * @Time 20:14
 * 公会名字修改事件
 */
@Value(staticConstructor = "of")
public class ClanEditNickEvent {

    private long gid;
    /**
     * 新名字
     */
    private String newNick;

    /**
     * 旧名字
     */
    private String oldNick;
}
