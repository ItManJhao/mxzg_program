package com.ayjs.mxzg.gameserver.module.hero.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.HeroFashionSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroFashionUnlockSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroFashionUpSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroFashion;
import com.ayjs.mxzg.config.excel.entity.CHeroFashionUnlock;
import com.ayjs.mxzg.config.excel.entity.CHeroFashionUp;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroFashion;
import com.ayjs.mxzg.gameserver.module.hero.event.FashionActiveEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.FashionUpLevelEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroFashionService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.hero.struct.FashionData;
import com.ayjs.mxzg.protocol.HeroFashionGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Objects;

/**
 * 英雄皮肤（时装）
 *
 * @author hyx
 */
@Component
public class HeroFashionHandler extends ProtocolHandler {

    @Autowired
    private HeroFashionService heroFashionService;
    @Autowired
    private HeroFashionUpSysCache heroFashionUpSysCache;
    @Autowired
    private HeroFashionUnlockSysCache heroFashionUnlockSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private HeroFashionSysCache heroFashionSysCache;
    @Autowired
    private EventBus eventBus;

    /**
     * 穿戴皮肤的英雄列表
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._4401)
    public void useFashionHeroList(PlayerContext playerContext, HeroFashionGMsg.GReqHeroFashion msg) {

        //刷新数据
        heroFashionService.selectAndRefresh(playerContext.getId());

        HeroFashionGMsg.GResHeroFashion.Builder builder = heroFashionService.sendHeroFashion(playerContext.getId());

        playerContext.write(CmdCode._4401, builder.build());
    }

    /**
     * 获取激活的皮肤列表
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._4402)
    public void heroFashionList(PlayerContext playerContext, HeroFashionGMsg.GReqHeroFashionList msg) {
        HeroFashionGMsg.GResHeroFashionList.Builder builder = heroFashionService.sendActiveFashion(playerContext.getId());
        playerContext.write(CmdCode._4402, builder.build());
    }

    /**
     * 激活皮肤
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._4403)
    public void activeFashion(PlayerContext playerContext, HeroFashionGMsg.GReqActiveHeroFashion msg) {
        HeroFashionGMsg.GResActiveHeroFashion.Builder builder = HeroFashionGMsg.GResActiveHeroFashion.newBuilder();

        CHeroFashionUnlock cHeroFashionUnlock = heroFashionUnlockSysCache.getOrThrow(msg.getItemType());

        HeroFashion heroFashion = heroFashionService.selectAndRefresh(playerContext.getId());
        // 检查是否有对应的英雄
        int fashion_id = cHeroFashionUnlock.getFashion_id();
        CHeroFashion fashionConfig = heroFashionSysCache.getOrThrow(fashion_id);
        List<Hero> heroes = heroService.selectHeroListByType(playerContext.getId(), fashionConfig.getHero_type());
        Asserts.isTrue(!heroes.isEmpty(), ErrorCode.HERO_IS_NOT_ACTIVE.getValue(),
                String.format("没有此皮肤{%s}对应的英雄{%s}，无法激活", fashion_id, fashionConfig.getHero_type()));

        FashionData fashionData = heroFashionService.selectFashionData(heroFashion, fashion_id);

        if (fashionData == null) {
            fashionData = new FashionData();
            fashionData.setLevel(0);
            fashionData.setFashionId(fashion_id);
            heroFashion.getFashionList().add(fashionData);
        } else {
            //若皮肤已永久激活
            Asserts.isTrue(fashionData.getStatus() == 1, ErrorCode.HERO_FASHION_PERMANENT_ACTIVATION.getValue(),
                    "该皮肤已永久激活，无需再次激活");

            //皮肤为期限激活，再次使用期限道具激活
            Asserts.isTrue(cHeroFashionUnlock.getType() == 0,
                    ErrorCode.HERO_FASHION_PERMANENT_ACTIVATION.getValue(), "该皮肤在期限道具激活有效期，不可再使用期限道具激活");

        }
        //扣除道具
        thingService.cost(playerContext.getId(), ImmutableThing.of(msg.getItemType(), 1), GameEvent.HERO_FASHION_ACTIVE);

        fashionData.setStatus(cHeroFashionUnlock.getType());
        fashionData.setTimeLimit(fashionData.getStatus() == 0 ? 0 : DateTimeUtil.currentSecond() + cHeroFashionUnlock.getTime_limit());
        heroFashionService.update(heroFashion);

        builder.setFashionId(fashion_id);
        playerContext.write(CmdCode._4403, builder.build());

        eventBus.post(FashionActiveEvent.of(heroFashion.getRid(), fashion_id, cHeroFashionUnlock.getType(), GameEvent.HERO_FASHION_ACTIVE));
    }

    /**
     * 替换或使用皮肤
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._4404)
    public void heroFashionCharge(PlayerContext playerContext, HeroFashionGMsg.GReqHeroFashionChange msg) {
        HeroFashionGMsg.GResHeroFashionChange.Builder builder = HeroFashionGMsg.GResHeroFashionChange.newBuilder();

        if (msg.getFashionId() != 0) {//使用皮肤才需验证。替换为默认皮肤0无需验证
            HeroFashion heroFashion = heroFashionService.selectAndRefresh(playerContext.getId());
            FashionData fashionData = heroFashionService.selectFashionData(heroFashion, msg.getFashionId());
            Asserts.notNull(fashionData, ErrorCode.HERO_FASHION_NOT_ACTIVE.getValue(), () -> "当前英雄皮肤尚未解锁或已过期：" + msg.getFashionId());
        }

        Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
        hero.setFashionId(msg.getFashionId());
        heroService.updateHero(hero);

        builder.setFashionId(msg.getFashionId());
        builder.setHeroId(msg.getHeroId());
        playerContext.write(CmdCode._4404, builder.build());
    }

    /**
     * 皮肤升级
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._4405)
    public void heroFashionUp(PlayerContext playerContext, HeroFashionGMsg.GReqHeroFashionUp msg) {
        HeroFashionGMsg.GResHeroFashionUp.Builder builder = HeroFashionGMsg.GResHeroFashionUp.newBuilder();

        HeroFashion heroFashion = heroFashionService.selectAndRefresh(playerContext.getId());
        FashionData fashionData = heroFashionService.selectFashionData(heroFashion, msg.getFashionId());
        Asserts.notNull(fashionData, ErrorCode.HERO_FASHION_NOT_ACTIVE.getValue(),
                () -> "当前英雄类型皮肤尚未解锁：" + msg.getFashionId());

        Asserts.isTrue(fashionData.getStatus() == 0, ErrorCode.HERO_FASHION_NOT_UP_LEVEL.getValue(),
                String.format("期限皮肤不能升级:{%s},rid:{%s}", msg.getFashionId(), playerContext.getId()));

        Asserts.isTrue(fashionData.getLevel() < heroFashionUpSysCache.getMaxLevel(msg.getFashionId()),
                ErrorCode.HERO_FASHION_MAX_LEVEL.getValue(), String.format("已达到该皮肤最大值:{%s},level:{%s}",
                        fashionData.getFashionId(), fashionData.getLevel()));

        CHeroFashionUp cHeroFashionUp = heroFashionUpSysCache.getHeroFashionUp(fashionData.getFashionId(),
                fashionData.getLevel()                          );

        thingService.cost(playerContext.getId(), cHeroFashionUp.getNeed_item(), GameEvent.HERO_FASHION_UP_LEVEL);

        fashionData.setLevel(fashionData.getLevel() + 1);
        heroFashionService.update(heroFashion);

        builder.setFashionId(msg.getFashionId());
        builder.setLevel(fashionData.getLevel());
        playerContext.write(CmdCode._4405, builder.build());

        eventBus.post(FashionUpLevelEvent.of(heroFashion.getRid(), msg.getFashionId(), fashionData.getLevel(), GameEvent.HERO_FASHION_UP_LEVEL));
    }
}
