package com.ayjs.mxzg.gameserver.module.role.event;

import lombok.Value;

/**
 * 角色名字修改事件
 */
@Value(staticConstructor = "of")
public class RoleEditNickEvent {

    private long rid;
    /**
     * 新名字
     */
    private String newNick;

    /**
     * 旧名字
     */
    private String oldNick;

}
