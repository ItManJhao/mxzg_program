package com.ayjs.mxzg.cross.module.crossrole.event;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2019/12/19
 **/
@Value(staticConstructor = "of")
public class RoleFightChangeEvent {

    private long rid;

    private long newFight;

    private int serverId;

//    private long oldFight;
}
