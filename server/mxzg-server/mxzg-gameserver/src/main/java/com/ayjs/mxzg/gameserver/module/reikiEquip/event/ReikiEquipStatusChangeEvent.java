package com.ayjs.mxzg.gameserver.module.reikiEquip.event;

import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.reikiEquip.domain.ReikiEquip;
import lombok.Value;

import java.util.List;

/**
 * 英雄删除灵器退回事件
 * @author hyx
 */
@Value(staticConstructor = "of")
public class ReikiEquipStatusChangeEvent {

    private long rid;

    private List<ReikiEquip> equipIds;

}
