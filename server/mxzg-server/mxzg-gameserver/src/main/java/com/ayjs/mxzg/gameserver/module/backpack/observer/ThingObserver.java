package com.ayjs.mxzg.gameserver.module.backpack.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.cache.ItemSysCache;
import com.ayjs.mxzg.config.excel.entity.CItem;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.event.ThingAddEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.ThingCostEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.processor.ThingType;
import com.ayjs.mxzg.gameserver.module.godequip.domain.GodEquip;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroMagicWand;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.BackPackGMsg;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Observer
public class ThingObserver {

    @Autowired
    private ContextManager contextManager;
    @Autowired
    private ItemSysCache itemSysCache;

    @Subscribe(async = Subscribe.AsyncType.Sync)
    private void onEvent(ThingAddEvent event) {
        BackPackGMsg.GResBackpackGain.Builder builder = BackPackGMsg.GResBackpackGain.newBuilder();
        builder.setType(event.getNotify().getValue());

        List<ObjectGMsg.PSBackpackData> psBackpackDataList = new ArrayList<>();
        for(GodEquip godEquip : event.getRewards().getGodEquips()){
            ObjectGMsg.PSBackpackData.Builder data = ObjectGMsg.PSBackpackData.newBuilder();
            data.setId(godEquip.getId());
            data.setType(godEquip.getSysId());
            data.setNum(1);
            psBackpackDataList.add(data.build());
        }

        for (Hero hero : event.getRewards().getHeroes()) {
            ObjectGMsg.PSBackpackData.Builder data = ObjectGMsg.PSBackpackData.newBuilder();
            data.setId(hero.getId());
            data.setType(hero.getType());
            data.setNum(1);
            data.setStar(hero.getStar());
            psBackpackDataList.add(data.build());
        }

        for (HeroMagicWand heroMagicWand : event.getRewards().getHeroMagicWands()) {
            ObjectGMsg.PSBackpackData.Builder data = ObjectGMsg.PSBackpackData.newBuilder();
            data.setId(heroMagicWand.getId());
            data.setType(heroMagicWand.getTypeId());
            data.setNum(1);
            psBackpackDataList.add(data.build());
        }

        for (ImmutableThing thing : event.getRewards().getThingSet().asList()) {
            CItem cItem = itemSysCache.getOrThrow(thing.getItem_type());
            if (cItem.getType() == ThingType.GOD_EQUIP.getType()
                    || cItem.getType() == ThingType.ITEM_HERO.getType()
                    || cItem.getType() == ThingType.HERO.getType()
                    || cItem.getType() == ThingType.MAGIC_WAND.getType()) {
                continue;
            }
            psBackpackDataList.add(PbUtil.buildReward(thing));
        }

        Collections.shuffle(psBackpackDataList);
        builder.addAllList(psBackpackDataList);

        contextManager.write(event.getRid(), CmdCode._5002, builder.build());
    }

    @Subscribe(async = Subscribe.AsyncType.Sync)
    private void onEvent(ThingCostEvent event) {
        //通知前端扣减资源
        BackPackGMsg.GResBackpackGain.Builder builder = BackPackGMsg.GResBackpackGain.newBuilder();
        builder.setType(NoticeType.SLIENT.getValue());
        for (ImmutableThing thing : event.getUpdate().asList()) {
            ObjectGMsg.PSBackpackData.Builder model = ObjectGMsg.PSBackpackData.newBuilder();
            model.setType(thing.getThingId());
            model.setNum(-thing.getNum());
            builder.addList(model.build());
        }
        contextManager.write(event.getRid(), CmdCode._5002, builder.build());
    }
}
