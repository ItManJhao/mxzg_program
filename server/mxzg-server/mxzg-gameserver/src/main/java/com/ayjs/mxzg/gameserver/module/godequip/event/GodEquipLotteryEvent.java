package com.ayjs.mxzg.gameserver.module.godequip.event;

import com.ayjs.mxzg.gameserver.module.godequip.domain.GodEquip;
import lombok.Value;

import java.util.List;

/**
 * 神装探宝事件
 * @author hyx
 */
@Value(staticConstructor = "of")
public class GodEquipLotteryEvent {

    private long rid;

    private List<GodEquip> godEquips;

}
