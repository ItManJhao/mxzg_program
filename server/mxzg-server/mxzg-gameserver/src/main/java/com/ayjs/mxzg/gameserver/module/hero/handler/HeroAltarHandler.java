/**
 *
 */
package com.ayjs.mxzg.gameserver.module.hero.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.GoddessVipSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroStarSysCache;
import com.ayjs.mxzg.config.excel.entity.CGoddessVip;
import com.ayjs.mxzg.config.excel.entity.CHeroStar;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.role.constant.EntryType;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.task.event.AlterHeroEvent;
import com.ayjs.mxzg.gameserver.module.tweakCube.service.TweakCubeService;
import com.ayjs.mxzg.protocol.Task1GMsg;
import com.ayjs.mxzg.protocol.Task1GMsg.GResAltarHero;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;

/**
 * @author
 * 英雄献祭
 */
@Controller
public class HeroAltarHandler extends ProtocolHandler {

    @Autowired
    private ThingService thingService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private HeroStarSysCache heroStarSysCache;
    @Autowired
    private GoddessVipSysCache goddessVipSysCache;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private HeroService heroService;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private TweakCubeService tweakCubeService;

    /**
     * 英雄献祭
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13051, entry = EntryType.MAIN_ALTAR)
    public void altarHero(PlayerContext playerContext, Task1GMsg.GReqAltarHero msg) {

        List<Hero> heroList = heroService.heroList(playerContext.getId(), msg.getHeroIdList());

        Asserts.isTrue(heroList.size() > 0, ErrorCode.HERO_ALTAR_NO_NULL.getValue(), "献祭的英雄不能为空。");

        List<ImmutableThing> rewardList = new ArrayList<>();
        for (Hero hero : heroList) {
            if (heroLineUpService.isHeroLockInLineUp(hero.getRid(), hero.getId())) {
                playerContext.writeError(ErrorCode.HERO_LOCKIN_LINEUP, "英雄" + hero.getId() + "在阵上");
                return;
            }

            Asserts.isTrue(!tweakCubeService.isInTrench(hero.getRid(), hero.getId()),
                    ErrorCode.TWEAK_CUBE_TRENCH_HERO_CANT_OPERATOR.getValue(),
                    String.format("槽位上的英雄{%s}不允许该操作", hero.getId()));
            Asserts.isTrue(hero.getIsLock() == 0, ErrorCode.HERO_LOCK.getValue(), "该英雄被锁定了");

            rewardList.addAll(heroService.heroCost(hero, 1, 0, 6));

            //英雄献祭基础收益
            CHeroStar cHeroStar = heroStarSysCache.getOrThrow(hero.getStar());
            rewardList.addAll(cHeroStar.getSacrifice_item_refund());
        }//end for
        Asserts.isTrue(!heroLineUpService.isHeroDeletes(playerContext.getId(), msg.getHeroIdList()), ErrorCode.HERO_CANT_DELETE_LINEUP_ALL.getValue(),
                "不能删除指定阵型上的所有英雄");

        //vip资源加成

        rewardList = ImmutableThingUtil.mergeThing(rewardList);

        CGoddessVip cModel = goddessVipSysCache.getOrThrow(roleService.getOrThrow(playerContext.getId()).getGoddessVip());
        if (cModel.getSacrifice_bonus() > 0) {
            List<ImmutableThing> finalRewardList = new ArrayList<>();

            for (ImmutableThing reward : rewardList) {
                finalRewardList.add(ImmutableThing.of(reward.getItem_type(), reward.getItem_num()
                        + (int) Math.floor(reward.getItem_num() * cModel.getSacrifice_bonus() / 100.0)));
            }
            rewardList = finalRewardList;
        }

        //删除英雄
        heroService.deleteHeros(playerContext.getId(), heroList, GameEvent.ALTAR_HERO);
        //加道具
        thingService.add(playerContext.getId(), rewardList, GameEvent.ALTAR_HERO);
        eventBus.post(AlterHeroEvent.of(playerContext.getId(), msg.getHeroIdList().size()));

        playerContext.write(CmdCode._13051, GResAltarHero.getDefaultInstance());
    }
}
