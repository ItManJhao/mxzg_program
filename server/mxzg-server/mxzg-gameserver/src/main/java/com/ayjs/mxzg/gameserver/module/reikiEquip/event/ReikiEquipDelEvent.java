package com.ayjs.mxzg.gameserver.module.reikiEquip.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.reikiEquip.domain.ReikiEquip;
import lombok.Value;

import java.util.List;

/**
 * 灵器删除事件
 * @author hyx
 */
@Value(staticConstructor = "of")
public class ReikiEquipDelEvent {
    private long rid;

    private List<ReikiEquip> list;

    private GameEvent gameEvent;
}
