package com.ayjs.mxzg.gameserver.module.hero.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.RewardGroupSysCache;
import com.ayjs.mxzg.config.excel.constant.HeroConst;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroPrayer;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroPrayerService;
import com.ayjs.mxzg.gameserver.module.hero.struct.PrayerType;
import com.ayjs.mxzg.protocol.HeroPrayerGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;

/**
 * 英雄祈愿
 *
 * @author hyx
 */
@Controller
public class HeroPrayerHandler extends ProtocolHandler {

    @Autowired
    private HeroPrayerService heroPrayerService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private RewardGroupSysCache rewardGroupSysCache;

    /**
     * 祈愿数据
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._4201)
    public void heroPrayerData(PlayerContext playerContext, HeroPrayerGMsg.GReqHeroPrayerData msg) {

        HeroPrayer heroPrayer = heroPrayerService.select(playerContext.getId());
        heroPrayerService.sendHeroPrayerData(heroPrayer);

    }

    /**
     * 祈愿召唤英雄
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._4202)
    public void prayerSummonHero(PlayerContext playerContext, HeroPrayerGMsg.GReqHeroPrayer msg) {
        HeroPrayerGMsg.GResHeroPrayer.Builder builder = HeroPrayerGMsg.GResHeroPrayer.newBuilder();

        HeroPrayer heroPrayer = heroPrayerService.select(playerContext.getId());
        Asserts.isTrue(heroPrayer.getPrayerPrivilege() == 1, ErrorCode.HERO_PRAYER_PRIVILEGE.getValue(), "祈愿权限未开通");

        Asserts.notNull(PrayerType.valueOf(msg.getElem()),ErrorCode.HERO_PRAYER_ELEM.getValue(),"不存在该类型的祈愿");

        thingService.cost(playerContext.getId(), ImmutableThing.of(ItemType.IT_PRAYER, HeroConst.ADV_SUMMON_WISH_TIME), GameEvent.HERO_PRAYER);

        List<ImmutableThing> rewardList = new ArrayList<>();
        if(msg.getElem() == PrayerType.FIRE.getType()){
            rewardList =rewardGroupSysCache.getRewardGroupThing(HeroConst.ADV_WISH_FIRE_REWARD_TYPE);
        }else if(msg.getElem() == PrayerType.WATER.getType()){
            rewardList =rewardGroupSysCache.getRewardGroupThing(HeroConst.ADV_WISH_WATER_REWARD_TYPE);
        }else if(msg.getElem() == PrayerType.WOOD.getType()){
            rewardList =rewardGroupSysCache.getRewardGroupThing(HeroConst.ADV_WISH_WOOD_REWARD_TYPE);
        }

        thingService.add(playerContext.getId(), rewardList, GameEvent.HERO_PRAYER);

        playerContext.write(CmdCode._4202, builder.build());
    }


}
