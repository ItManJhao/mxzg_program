package com.ayjs.mxzg.gameserver.module.godequip.event;

import com.ayjs.mxzg.gameserver.module.godequip.domain.GodEquip;
import lombok.Value;

/**
 * 神装升星事件
 * @author hyx
 */
@Value(staticConstructor = "of")
public class GodEquipUpStarEvent {

    private long rid;

    private GodEquip godEquip;

}
