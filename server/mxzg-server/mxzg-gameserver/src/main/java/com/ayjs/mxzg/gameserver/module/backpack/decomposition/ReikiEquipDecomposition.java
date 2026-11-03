package com.ayjs.mxzg.gameserver.module.backpack.decomposition;


import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.processor.ThingType;
import com.ayjs.mxzg.gameserver.module.reikiEquip.domain.ReikiEquip;
import com.ayjs.mxzg.gameserver.module.reikiEquip.service.ReikiEquipService;
import com.ayjs.mxzg.protocol.BackPackGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class ReikiEquipDecomposition implements ThingDecomposition {

    @Autowired
    private ReikiEquipService reikiEquipService;

    @Override
    public ThingType getType() {
        return ThingType.REIKI_EQUIP;
    }

    @Override
    public void decomposition(long rid, BackPackGMsg.ResBackPackItem item, GameEvent gameEvent) {
        ReikiEquip reikiEquip = reikiEquipService.select(rid, item.getItemId());
        Asserts.isTrue(reikiEquip.getHeroId() == 0, ErrorCode.REIKI_EQUIP_USED.getValue(), "灵器装备在英雄身上无法分解");
        reikiEquipService.delete(reikiEquip,gameEvent);
    }
}
