package com.ayjs.mxzg.gameserver.module.reikiEquip.event;

import lombok.Value;

/**
 * 灵器升星
 * @author hyx
 */
@Value(staticConstructor = "of")
public class ReikiEquipUpStarEvent {

    private long rid;

    private long equipId;

}
