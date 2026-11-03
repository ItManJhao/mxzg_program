package com.ayjs.mxzg.gameserver.module.reikiEquip.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import lombok.Value;

/**
 * 灵器槽位激活事件
 * @author hyx
 */
@Value(staticConstructor = "of")
public class ReikiEquipActiveEvent {

    private long rid;

    private int sysId;

    private GameEvent gameEvent;

}
