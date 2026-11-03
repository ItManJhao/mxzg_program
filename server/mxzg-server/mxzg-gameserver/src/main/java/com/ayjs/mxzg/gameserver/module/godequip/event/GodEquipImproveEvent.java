package com.ayjs.mxzg.gameserver.module.godequip.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.GodAttr;
import lombok.Value;

import java.util.List;

/**
 * 神装洗炼保存
 * @author hyx
 */
@Value(staticConstructor = "of")
public class GodEquipImproveEvent {

    private long rid;

    private long godEquipId;

    private long heroId;

    private List<GodAttr> oldAbility;

    private List<GodAttr> newAbility;

    private GameEvent gameEvent;

}
