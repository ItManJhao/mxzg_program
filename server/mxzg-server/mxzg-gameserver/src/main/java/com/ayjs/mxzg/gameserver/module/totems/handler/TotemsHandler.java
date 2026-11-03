package com.ayjs.mxzg.gameserver.module.totems.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.totems.TotemsLevelSysCache;
import com.ayjs.mxzg.config.excel.cache.totems.TotemsSysCache;
import com.ayjs.mxzg.config.excel.entity.totems.CTotems;
import com.ayjs.mxzg.config.excel.entity.totems.CTotemsLevel;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.totems.domain.Totems;
import com.ayjs.mxzg.gameserver.module.totems.event.TotemsOpreaEvent;
import com.ayjs.mxzg.gameserver.module.totems.event.TotemsResetEvent;
import com.ayjs.mxzg.gameserver.module.totems.event.TotemsUpEvent;
import com.ayjs.mxzg.gameserver.module.totems.service.TotemsService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.TotemsGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class TotemsHandler extends ProtocolHandler {

    @Autowired
    private ThingService thingService;
    @Autowired
    private TotemsService totemsService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private TotemsSysCache totemsSysCache;
    @Autowired
    private TotemsLevelSysCache totemsLevelSysCache;
    @Autowired
    private HeroService heroService;


    /**
     * 获取图腾信息列表
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._74300)
    public void sendTotemsDate(PlayerContext playerContext, TotemsGMsg.GReqTotemsInfoList msg) {
        TotemsGMsg.GResTotemsInfoList.Builder builder = TotemsGMsg.GResTotemsInfoList.newBuilder();
        List<Totems> totemsList = totemsService.getTotemsList(playerContext.getId());
        totemsList.forEach(totems -> {
            builder.addList(totemsService.builderTotemsInfo(totems));
        });
        playerContext.write(CmdCode._74300, builder.build());
    }


    /**
     * 图腾升级、升阶
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._74301)
    public void upLevelTotems(PlayerContext playerContext, TotemsGMsg.GReqTotemsUp msg) {
        int type = msg.getType();
        long tId = msg.getTId();
        Asserts.isTrue(type == 1 || type == 2, ErrorCode.TOTEMS_CLIENT_PARAMS_ERRE.getValue(),
                String.format("图腾升级、升阶参数操作类型错误{%s}", type));
        Totems totems = totemsService.getTotems_byId(playerContext.getId(), tId);

        Asserts.notNull(totems, ErrorCode.TOTEMS_ACHIEVE_NO.getValue(), String.format("图腾:{%s}不存在", msg.getTId()));
        CTotems cTotems = totemsSysCache.getCTotems_key(totems.getTotems_id(), totems.getQuality());
        CTotemsLevel cTotemsLevel = totemsLevelSysCache.getCTotemsLevel_key(totems.getTotems_id(), totems.getLevel());
        int nowLevel = totems.getLevel();
        if (type == 1) {//升级
            CTotems cTotems_next = totemsSysCache.getCTotems_key(totems.getTotems_id(), totems.getQuality() + 1);//下一阶模板
            if (cTotems_next != null) {
                //应该要先升阶
                Asserts.isTrue(nowLevel < cTotems_next.getNeedlevel(), ErrorCode.TOTEMS_SHOULD_QUALITY.getValue(),
                        String.format("图腾已经达到升阶等级{%s},tId{%s}", totems.getLevel(), totems.getId()));
            }
            CTotemsLevel cTotemsLevel_next = totemsLevelSysCache.getCTotemsLevel_key(totems.getTotems_id(), totems.getLevel() + 1);
            //没有下一级
            Asserts.notNull(cTotemsLevel_next, ErrorCode.TOTEMS_LEVEL_FULL.getValue(), String.format("图腾:{%s}等级已达上限{%s}", msg.getTId(), totems.getLevel()));
            //升级，消耗当前级配置材料
            thingService.cost(playerContext.getId(), cTotemsLevel.getCost(), GameEvent.TOTEMS_UP_LEVEL_COST);
            totems.setLevel(totems.getLevel() + 1);
            totemsService.updateTotems(totems);
        } else if (type == 2) {//升阶
            CTotems cTotems_next = totemsSysCache.getCTotems_key(totems.getTotems_id(), totems.getQuality() + 1);//下一阶模板
            //没有下一阶
            Asserts.notNull(cTotems_next, ErrorCode.TOTEMS_QUALITY_FULL.getValue(), String.format("图腾:{%s}品质已达上限{%s}", msg.getTId(), totems.getQuality()));
            //没有达到升阶等级
            Asserts.isTrue(nowLevel == cTotems_next.getNeedlevel(), ErrorCode.TOTEMS_QUALITY_LEVEL_NO.getValue(),
                    String.format("图腾没有到达升阶等级{%s},tId{%s}", totems.getLevel(), totems.getId()));
            thingService.cost(playerContext.getId(), cTotems.getCost(), GameEvent.TOTEMS_UP_QUALITY_COST);
            totems.setQuality(totems.getQuality() + 1);
            totemsService.updateTotems(totems);
        }

        TotemsGMsg.GResTotemsUp.Builder builder = TotemsGMsg.GResTotemsUp.newBuilder();
        builder.setTotems(totemsService.builderTotemsInfo(totems));
        builder.setType(type);
        playerContext.write(CmdCode._74301, builder.build());

        //抛出升级、升阶段事件
        eventBus.post(TotemsUpEvent.of(playerContext.getId(), totems.getId(), totems.getHeroId()));
    }

    /**
     * 图腾装备、卸下、更换
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._74302)
    public void totemsOprea(PlayerContext playerContext, TotemsGMsg.GReqTotemsOprea msg) {
        int type = msg.getType();//操作类型 1：装备  2：卸下  3：更换
        long tId = msg.getTId();//图腾id
        long heroId = msg.getHeroId();//英雄id
        Asserts.isTrue(type == 1 || type == 2 || type == 3, ErrorCode.TOTEMS_CLIENT_PARAMS_ERRE.getValue(),
                String.format("图腾装备、卸下、更换参数操作类型错误{%s}", type));
        Totems totems = totemsService.getTotems_byId(playerContext.getId(), tId);
        Asserts.notNull(totems, ErrorCode.TOTEMS_ACHIEVE_NO.getValue(), String.format("图腾:{%s}不存在", tId));
        Hero hero = heroService.getHero(playerContext.getId(), heroId);
        Asserts.notNull(hero, ErrorCode.HERO_NOT_EXIST.getValue(), String.format("英雄{%s}不存在", heroId));
        //当前英雄装备的图腾
        Totems totemsOld = totemsService.getTotems_byHero(playerContext.getId(), heroId);
        if (type == 1) {//装备
            if (totemsOld != null) {
                Asserts.isTrue(totemsOld.getId() != tId, ErrorCode.TOTEMS_HERO_ALREADY.getValue(),
                        String.format("英雄{%s}已经装备了该图腾{%s}", heroId,tId));
                totemsOld.setHeroId(0);
                totemsService.updateTotems(totemsOld);
            }
            totems.setHeroId(heroId);
            totemsService.updateTotems(totems);
        } else if (type == 2) {//卸下
            Asserts.notNull(totemsOld, ErrorCode.TOTEMS_HERO_NO.getValue(), String.format("英雄没有装备图腾，英雄:{%s}", heroId));
            totemsOld.setHeroId(0);
            totemsService.updateTotems(totemsOld);
        } else if (type == 3) {//更换
            if (totemsOld != null) {
                Asserts.isTrue(totemsOld.getId() != tId, ErrorCode.TOTEMS_HERO_ALREADY.getValue(),
                        String.format("英雄{%s}已经装备了该图腾{%s}", heroId,tId));
                totemsOld.setHeroId(0);
                totemsService.updateTotems(totemsOld);
            }
            totems.setHeroId(heroId);
            totemsService.updateTotems(totems);
        }
        TotemsGMsg.GResTotemsOprea.Builder builder = TotemsGMsg.GResTotemsOprea.newBuilder();
        if (type == 2) {//卸下
            builder.addList(totemsService.builderTotemsInfo(totemsOld));
        } else {
            builder.addList(totemsService.builderTotemsInfo(totems));
            if (totemsOld != null && totemsOld.getId() != tId) {
                builder.addList(totemsService.builderTotemsInfo(totemsOld));
            }
        }
        builder.setType(type);
        playerContext.write(CmdCode._74302, builder.build());
        //抛出图腾操作事件
        eventBus.post(TotemsOpreaEvent.of(playerContext.getId(), heroId));
    }


    /**
     * 图腾重置
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._74303)
    public void totemsReset(PlayerContext playerContext, TotemsGMsg.GReqTotemsReset msg) {
        long tId = msg.getTId();
        Totems totems = totemsService.getTotems_byId(playerContext.getId(), tId);
        Asserts.notNull(totems, ErrorCode.TOTEMS_ACHIEVE_NO.getValue(), String.format("图腾:{%s}不存在", tId));
        Asserts.isTrue(totems.getLevel() > 1, ErrorCode.TOTEMS_LEVEL_LOW_NORESET.getValue(),
                String.format("图腾当前最低级，无法重置{%s}", tId));

        //统计当前图腾消耗的材料
        int level = totems.getLevel();
        int quality = totems.getQuality();
        List<ImmutableThing> things = new ArrayList<>();
        for (int i = 1; i < level; i++) {
            CTotemsLevel cTotemsLevel = totemsLevelSysCache.getCTotemsLevel_key(totems.getTotems_id(), i);
            if (cTotemsLevel.getCost() != null && !cTotemsLevel.getCost().isEmpty()) {
                things.addAll(cTotemsLevel.getCost());
            }
        }
        for (int i = 1; i < quality; i++) {
            CTotems cTotems = totemsSysCache.getCTotems_key(totems.getTotems_id(), i);
            if (cTotems.getCost() != null && !cTotems.getCost().isEmpty()) {
                things.addAll(cTotems.getCost());
            }
        }
        //重置图腾
        totems.setLevel(1);
        totems.setQuality(1);
        totemsService.updateTotems(totems);
        //合并奖励集合
        List<ImmutableThing> things_all = ImmutableThingUtil.mergeThing(things);
        Rewards rewards = thingService.add(playerContext.getId(), things_all,
                GameEvent.TOTEMS_RESET_ITEM, NoticeType.NORMAL);

        TotemsGMsg.GResTotemsReset.Builder builder = TotemsGMsg.GResTotemsReset.newBuilder();
        builder.setTotems(totemsService.builderTotemsInfo(totems));
//        builder.addAllItems(PbUtil.buildReward(rewards));
        playerContext.write(CmdCode._74303, builder.build());

        //抛出图腾重置事件
        eventBus.post(TotemsResetEvent.of(playerContext.getId(), tId, totems.getHeroId()));
    }

}
