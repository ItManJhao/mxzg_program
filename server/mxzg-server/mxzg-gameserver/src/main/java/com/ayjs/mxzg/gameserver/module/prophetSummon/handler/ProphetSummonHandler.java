package com.ayjs.mxzg.gameserver.module.prophetSummon.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.ProphecyExchangeSysCache;
import com.ayjs.mxzg.config.excel.cache.RewardGroupSysCache;
import com.ayjs.mxzg.config.excel.constant.ProphecyConst;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.excel.entity.CProphecyExchange;
import com.ayjs.mxzg.config.excel.entity.CProphecyType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroSummon;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroDeleteEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroGetEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroEvolveService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroSummonService;
import com.ayjs.mxzg.gameserver.module.prophetSummon.domain.HeroChange;
import com.ayjs.mxzg.gameserver.module.prophetSummon.event.HeroChangeAffirmEvent;
import com.ayjs.mxzg.gameserver.module.prophetSummon.event.HeroChangeEvent;
import com.ayjs.mxzg.gameserver.module.prophetSummon.event.ProphetSummonEvent;
import com.ayjs.mxzg.gameserver.module.prophetSummon.service.HeroChangeService;
import com.ayjs.mxzg.gameserver.module.prophetSummon.service.ProphetSummonService;
import com.ayjs.mxzg.gameserver.module.role.constant.EntryType;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.ProphetSummonGMsg;
import com.ayjs.mxzg.protocol.ProphetSummonGMsg.GReqProphetChange;
import com.ayjs.mxzg.protocol.ProphetSummonGMsg.GReqProphetSummon;
import com.ayjs.mxzg.protocol.ProphetSummonGMsg.GReqProphetSummonInfo;
import com.ayjs.mxzg.protocol.ProphetSummonGMsg.GResProphetChange;
import com.ayjs.mxzg.protocol.ProphetSummonGMsg.GResProphetConfirmChange;
import com.ayjs.mxzg.protocol.ProphetSummonGMsg.GResProphetSummon;
import com.ayjs.mxzg.protocol.ProphetSummonGMsg.GResProphetSummonInfo;
import com.ayjs.mxzg.protocol.ProphetSummonGMsg.PSProphetLucky;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.ImmutableList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

@Controller
public class ProphetSummonHandler extends ProtocolHandler {

    @Autowired
    private ThingService thingService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private HeroChangeService heroChangeService;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private ProphecyExchangeSysCache prophecyExchangeSysCache;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private RewardGroupSysCache rewardGroupSysCache;
    @Autowired
    private ProphetSummonService prophetSummonService;
    @Autowired
    private HeroSummonService heroSummonService;
    @Autowired
    private HeroEvolveService heroEvolveService;


    /**
     * 先知抽奖
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13041, entry = EntryType.MAIN_PROPHET_TREE)
    public void prophetSummon(PlayerContext playerContext, GReqProphetSummon msg) {

        //获取抽奖类型
        int type = msg.getIndex();

        //扣道具
        ImmutableThing thing = ImmutableThing.of(ItemType.IT_PROPHET_BEAD, ProphecyConst.SUMMON_COST);
        thingService.cost(playerContext.getId(), thing, GameEvent.PROPHECY_LOTTERY_COST);

        CProphecyType cProphecyType = prophetSummonService.prophetSummon(playerContext.getId(), type);

        //额外奖励
        List<ImmutableThing> rewardList = ProphecyConst.SUMMON_GAIN_ITEM_EACH_PLAY;
        //召唤奖励=随机奖励+额外奖励
        List<ImmutableThing> resultList = new ArrayList<>();
        resultList.addAll(cProphecyType.getItem());
        resultList.addAll(rewardList);
        List<ImmutableThing> newReward = ImmutableThingUtil.mergeThing(resultList);
        //添加道具
        Rewards rewards = thingService.add(playerContext.getId(), newReward, GameEvent.PROPHECY_LOTTERY_GET, NoticeType.SLIENT);

        GResProphetSummon.Builder builder = GResProphetSummon.newBuilder();
        builder.addAllList(PbUtil.buildReward(rewards));
        playerContext.write(CmdCode._13041, builder.build());

        //抛出事件
        eventBus.post(ProphetSummonEvent.of(playerContext.getId(), 1, cProphecyType));
    }

    /**
     * 先知置换英雄
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13042)
    public void getProphetChange(PlayerContext playerContext, GReqProphetChange msg) {

        GResProphetChange.Builder builder = GResProphetChange.newBuilder();

        HeroChange heroChange = heroChangeService.getHeroChange(playerContext.getId());
        // 查询相应的配置表 将与被置换的英雄一样星级和等级的type存起来
        // 先查询改英雄对应的星级和等级
        if (msg.getHeroId() == 0) {
            builder.setBeforeHeroId(heroChange.getOldHeroId());
            builder.setAfterHeroType(heroChange.getNewType());
            playerContext.write(CmdCode._13042, builder.build());
        } else {
            Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
            if (hero == null || (hero.getStar() != 4 && hero.getStar() != 5)) {
                playerContext.writeError(ErrorCode.PROPHECY_HERO_CHANGE);
                return;
            }

            Asserts.isTrue(hero.getIsLock() == 0, ErrorCode.HERO_LOCK.getValue(), "该英雄被锁定了");

            Role role = roleService.getOrThrow(playerContext.getId());

            if (hero.getStar() == 5) {
                thingService.cost(role.getId(), ProphecyConst.EXCHANGE_COST, GameEvent.PROPHECY_CHANGE_COST);
            } else {
                thingService.cost(role.getId(), ProphecyConst.EXCHANGE_COST4, GameEvent.PROPHECY_CHANGE_COST);
            }

            CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getType());

            CProphecyExchange prophecyExchange = prophecyExchangeSysCache.getProphecyExchange(cHeroType.getElem(), cHeroType.getStar());

            int newHeroType = hero.getType();
            int i = 0;
            while (newHeroType == hero.getType()) {
                ImmutableList<ImmutableThing> rewardGroupThing = rewardGroupSysCache.getRewardGroupThing(prophecyExchange.getGroup_id());
                newHeroType = rewardGroupThing.get(0).getItem_type();
                if (i >= 1000) {
                    // 防止死循环
                    break;
                }
                i++;
            }

            heroChange.setOldHeroId(hero.getId());
            heroChange.setNewType(newHeroType);
            heroChangeService.updateHeroChange(heroChange);

            builder.setBeforeHeroId(heroChange.getOldHeroId());
            builder.setAfterHeroType(heroChange.getNewType());
            playerContext.write(CmdCode._13042, builder.build());

            eventBus.post(HeroChangeEvent.of(role.getId()));

        }
    }

    /**
     * 确认置换
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13043)
    public void confirmChange(PlayerContext playerContext, ProphetSummonGMsg.GReqProphetConfirmChange msg) {

        HeroChange heroChange = heroChangeService.getHeroChange(playerContext.getId());

        if (msg.getIndex() == 1) {//确定置换
            CHeroType cHeroType = heroTypeSysCache.getOrThrow(heroChange.getNewType());
            Hero hero = heroService.getHero(playerContext.getId(), heroChange.getOldHeroId());

            List<Hero> delHeroList = new ArrayList<>();
            Hero hero2 = new Hero();
            hero2.setRid(hero.getRid());
            hero2.setId(hero.getId());
            hero2.setLevel(hero.getLevel());
            hero2.setStar(hero.getStar());
            hero2.setStage(hero.getStage());
            hero2.setType(hero.getType());
            delHeroList.add(hero2);
            eventBus.post(HeroDeleteEvent.of(playerContext.getId(), delHeroList, GameEvent.PROPHECY_HERO_EXCHANGE));

            hero.setType(heroChange.getNewType());
            hero.setFashionId(0);
            heroService.updateHero(hero);

            List<Hero> addHeroList = new ArrayList<>();
            addHeroList.add(hero);
            eventBus.post(HeroGetEvent.of(playerContext.getId(), addHeroList, GameEvent.PROPHECY_HERO_EXCHANGE));
            eventBus.post(HeroChangeAffirmEvent.of(playerContext.getId()));
        }

        heroChange.setNewType(0);
        heroChange.setOldHeroId(0);
        heroChangeService.updateHeroChange(heroChange);

        playerContext.write(CmdCode._13043, GResProphetConfirmChange.getDefaultInstance());
    }

    @CMD(id = CmdCode._13044)
    public void scanLucky(PlayerContext playerContext, GReqProphetSummonInfo msg) {
        HeroSummon heroSummon = heroSummonService.getHeroSummon(playerContext.getId());

        GResProphetSummonInfo.Builder builder = GResProphetSummonInfo.newBuilder();
        for (Entry<Integer, Map<Integer, Integer>> entry : heroSummon.getProphetMissTimes().entrySet()) {
            PSProphetLucky.Builder model = PSProphetLucky.newBuilder();
            model.setType(entry.getKey());
            //记录先知召唤次数的结构设计有误，嵌套中的Map只会有一个元素
            for (Integer count : entry.getValue().values()) {
                model.setLucky(count);
            }
            builder.addLuckys(model.build());
        }
        playerContext.write(CmdCode._13044, builder.build());
    }
}
