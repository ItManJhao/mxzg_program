package com.ayjs.mxzg.gameserver.module.border.event;

import lombok.Value;

/**
 * 玩家头像框更换
 * @author hyx
 */
@Value(staticConstructor = "of")
public class RoleBorderEvent  {

    private long rid;

    private int borderId;

}
