package com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.handler;


import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.cache.NoticeSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.cache.crusadegroup.CrusadeGroupBuildSysCache;
import com.ayjs.mxzg.config.excel.cache.crusadegroup.CrusadeGroupMapSysCache;
import com.ayjs.mxzg.config.excel.cache.shenbin.ShenBinCoreSysCache;
import com.ayjs.mxzg.config.excel.cache.shenbin.ShenBinHoleSysCache;
import com.ayjs.mxzg.config.excel.cache.shenbin.ShenBinResolveSysCache;
import com.ayjs.mxzg.config.excel.cache.shenbin.ShenBinSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import com.ayjs.mxzg.config.excel.entity.CNotice;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupBuild;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupMap;
import com.ayjs.mxzg.config.excel.entity.shenbin.CShenBin;
import com.ayjs.mxzg.config.excel.entity.shenbin.CShenBinCore;
import com.ayjs.mxzg.config.excel.entity.shenbin.CShenBinHole;
import com.ayjs.mxzg.config.excel.entity.shenbin.CShenBinResolve;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.chat.constant.ChatType;
import com.ayjs.mxzg.gameserver.module.chat.service.ChatService;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.CrusadeGroupHero;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.RoleCrusadeGroup;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.service.GroupService;
import com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.domain.ShenBinCore;
import com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.domain.ShenBinEquip;
import com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.event.ShenBinCoreUpEvent;
import com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.service.ShenBinService;
import com.ayjs.mxzg.gameserver.module.hero.command.ModuleType;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.rank.service.impl.CrossCGHurtPRankService;
import com.ayjs.mxzg.gameserver.module.rank.service.impl.CrossCGHurtRankService;
import com.ayjs.mxzg.gameserver.module.rank.service.impl.CrossCGItemPRankService;
import com.ayjs.mxzg.gameserver.module.rank.service.impl.CrossCGItemRankService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.CrusadeGroupRankGMsg;
import com.ayjs.mxzg.protocol.CrusadeGroupShenBinGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.language.LanguageHelper;
import com.google.common.collect.ImmutableList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
public class ShenBinHandler extends ProtocolHandler {

    @Autowired
    private ThingService thingService;
    @Autowired
    private ShenBinService shenBinService;
    @Autowired
    private ShenBinSysCache shenBinSysCache;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private ShenBinHoleSysCache shenBinHoleSysCache;
    @Autowired
    private ShenBinCoreSysCache shenBinCoreSysCache;
    @Autowired
    private ShenBinResolveSysCache shenBinResolveSysCache;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private GroupService groupService;
    @Autowired
    private CrossCGItemRankService crossCGItemRankService;
    @Autowired
    private CrossCGItemPRankService crossCGItemPRankService;
    @Autowired
    private CrossCGHurtRankService crossCGHurtRankService;
    @Autowired
    private CrossCGHurtPRankService crossCGHurtPRankService;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private NoticeSysCache noticeSysCache;
    @Autowired
    private CrusadeGroupMapSysCache crusadeGroupMapSysCache;
    @Autowired
    private CrusadeGroupBuildSysCache crusadeGroupBuildSysCache;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private MailService mailService;
    @Autowired
    private ChatService chatService;
    @Autowired
    private LanguageHelper languageHelper;
    @Autowired
    private HeroService heroService;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;

    /**
     * 获取神兵信息
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._75601)
    public void shenBinInfo(PlayerContext playerContext, CrusadeGroupShenBinGMsg.GReqShenBinInfo msg) {
        long rid = playerContext.getId();
        int heroJobMax = systemSysCache.getHeroJobMax();//英雄职业最大值
        List<ShenBinEquip> shenBinEquips = shenBinService.getRoleShenBin(rid);
        Map<Integer, List<ShenBinEquip>> jobEquips = ListMapUtil.fillListMap(shenBinEquips, ShenBinEquip::getJob);
        CrusadeGroupShenBinGMsg.GResShenBinInfo.Builder builder = CrusadeGroupShenBinGMsg.GResShenBinInfo.newBuilder();
        for (int job = 1; job <= heroJobMax; job++) {//根据职业区分
            CrusadeGroupShenBinGMsg.PSShenBinInfo.Builder shenBinInfo = CrusadeGroupShenBinGMsg.PSShenBinInfo.newBuilder();//1
            CrusadeGroupShenBinGMsg.PSShenBinEquipData.Builder hEquips = CrusadeGroupShenBinGMsg.PSShenBinEquipData.newBuilder();//2
            hEquips.setJob(job);
            List<ShenBinEquip> list = jobEquips.get(job);
            if (list != null) {
                for (ShenBinEquip equip : list) {
                    // 没有按装备的部位进行排序
                    hEquips.addEquipList(PbUtil.buildShenBinEquip(equip));
                }
            }
            shenBinInfo.setJob(job);
            ShenBinCore shenBinCore = shenBinService.getRoleShenBinCore(rid, job);
            shenBinInfo.setCoreLv(shenBinCore.getCoreLv());
            shenBinInfo.setEquipData(hEquips);
            shenBinInfo.setFighting(getShenBinFighting_job(rid, job));//神兵战力
            builder.addShenBinInfos(shenBinInfo);
        }
        playerContext.write(CmdCode._75601, builder.build());
    }

    /**
     * 神兵合成
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._75602)
    public void shenBinCompose(PlayerContext playerContext, CrusadeGroupShenBinGMsg.GReqShenBinCompose msg) {
        int sbId = msg.getEquipType();
        long rid = playerContext.getId();
        CShenBin cShenBin = shenBinSysCache.getCShenBinTemplate(sbId);
        Asserts.notNull(cShenBin, ErrorCode.SHENBIN_TEMPLATE_ERROR.getValue(), String.format("神兵模板:{%s}为null", sbId));
        Map<Integer, ImmutableThing> compose_sb_result = new HashMap<>();//需要消耗的神兵集合
        List<ImmutableThing> compose_item_result = new ArrayList<>();//需要消耗的道具集合
        //找能合成该神兵的所有装备
        if (CollectionUtil.isEmpty(cShenBin.getCompose_sb())) {//所需神兵为null,说明只需要材料即可合成
            compose_item_result.addAll(cShenBin.getCompose_item());
        } else {
            //根据品质判断当前需要计算次数
            int quality = cShenBin.getQuality();//当前要合成的神兵品质
            //key:神兵id  value：数量
            Map<Integer, Long> templateNeedMap = new HashMap<>();
            templateNeedMap.put(sbId, 1l);//当前需要合成的神兵
            for (int i = 0; i < quality; i++) {
                Map<Integer, Long> templateNeedMap_ = new HashMap<>();
                for (Map.Entry<Integer, Long> entry : templateNeedMap.entrySet()) {
                    int shenBinId = entry.getKey();//神兵id
                    long num = entry.getValue();//需要合成的神兵数量
                    CShenBin template = shenBinSysCache.getCShenBinTemplate(shenBinId);
                    ImmutableList<ImmutableThing> compose_sb_temp = template.getCompose_sb();//需要消耗的神兵集合
                    if (CollectionUtil.isEmpty(compose_sb_temp)) {//只需要消耗道具将
                        ImmutableList<ImmutableThing> compose_item_temp = template.getCompose_item();
                        for (int n = 0; n < num; n++) {//需要合成多少神兵，就需要多少材料
                            compose_item_result.addAll(compose_item_temp);
                        }
                        continue;
                    }
                    //检查当前背包消耗神兵是否足够
                    for (ImmutableThing thing : compose_sb_temp) {
                        int thingType = thing.getItem_type();//消耗的神兵id
                        long needNum = thing.getItem_num();//合成1个神兵需要消耗的数量
                        long needAllNum = needNum * num;//合成多个神兵需要消耗的数量
                        long ownNum = thingService.getCount(rid, thingType);//当前背包的神兵数量
                        ownNum -= getSbNum(compose_sb_result, thingType);//先减去已经消耗的
                        if (ownNum <= 0) {//背包没有
                            long nowNum = templateNeedMap_.getOrDefault(thingType, 0l);
                            templateNeedMap_.put(thingType, nowNum + needAllNum);
                            continue;
                        }
                        if (ownNum >= needAllNum) {//背包足够
                            addSbItem(compose_sb_result, thingType, needAllNum);
//                            compose_sb_result.add(ImmutableThing.of(thingType, needAllNum));
                            continue;
                        }
                        //背包不够，其他的消耗再继续找
                        addSbItem(compose_sb_result, thingType, ownNum);
//                        compose_sb_result.add(ImmutableThing.of(thingType, ownNum));
                        long nowNum = templateNeedMap_.getOrDefault(thingType, 0l);
                        templateNeedMap_.put(thingType, nowNum + (needAllNum - ownNum));//还需要的数量
                    }
                }
                //神兵足够合成
                if (CollectionUtil.isEmpty(templateNeedMap_)) {
                    break;
                }
                templateNeedMap = templateNeedMap_;//将数据赋值给计算集合继续查找
            }
        }
        if (CollectionUtil.isEmpty(compose_item_result) && CollectionUtil.isEmpty(compose_sb_result)) {
            Asserts.isTrue(false, ErrorCode.SHENBIN_COMPOSE_ITEM_ERROR.getValue(),
                    String.format("神兵合成错误,找不到需要合成的材料,sbId:{%s}", sbId));
        }
        //计算消耗
        if (!CollectionUtil.isEmpty(compose_item_result)) {//扣除道具
//            boolean enough = thingService.enough(rid, compose_item_result);
//            Asserts.isTrue(enough, ErrorCode.BAG_ITEM_LACK.getValue(), "道具不足");
            List<ImmutableThing> compose_item_result_ = ImmutableThingUtil.mergeThing(compose_item_result);//合并道具
            thingService.cost(rid, compose_item_result_, GameEvent.SHENBIN_COMPOSE_ITEM);
        }
        if (!CollectionUtil.isEmpty(compose_sb_result)) {//扣除神兵
            thingService.cost(rid, new ArrayList<>(compose_sb_result.values()), GameEvent.SHENBIN_COMPOSE_SB);
        }
        //添加道具
        ImmutableThing thing = ImmutableThing.of(cShenBin.getSb_id(), 1);
        Rewards rewards = thingService.add(rid, thing, GameEvent.SHENBIN_COMPOSE_SB_ADD);
        CrusadeGroupShenBinGMsg.GResShenBinCompose.Builder builder = CrusadeGroupShenBinGMsg.GResShenBinCompose.newBuilder();
        builder.setShenbin(PbUtil.buildReward(thing));
        playerContext.write(CmdCode._75602, builder.build());
    }


    private void addSbItem(Map<Integer, ImmutableThing> compose_sb_result, int thingType, long needAllNum) {
        ImmutableThing immutableThing = compose_sb_result.get(thingType);
        if (immutableThing == null) {
            immutableThing = ImmutableThing.of(thingType, needAllNum);
            compose_sb_result.put(thingType, immutableThing);
            return;
        }
        long nowNum = immutableThing.getItem_num();
        compose_sb_result.put(thingType, ImmutableThing.of(thingType, nowNum + needAllNum));
    }

    private long getSbNum(Map<Integer, ImmutableThing> compose_sb_result, int thingType) {
        ImmutableThing immutableThing = compose_sb_result.get(thingType);
        if (immutableThing == null) {
            return 0;
        }
        return immutableThing.getItem_num();
    }

    /**
     * 神兵装备
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._75603)
    public void shenBinEquip(PlayerContext playerContext, CrusadeGroupShenBinGMsg.GReqShenBinEquip msg) {
        long rid = playerContext.getId();
        int job = msg.getJob();
        int place = msg.getPlace();
        int heroJobMax = systemSysCache.getHeroJobMax();//英雄职业最大值
        Asserts.isTrue(job >= 1 && job <= heroJobMax, ErrorCode.SHENBIN_EQUIP_PARAM_ERROR.getValue(),
                String.format("神兵装备参数错误job:{%s}", job));
        ShenBinCore shenBinCore = shenBinService.getRoleShenBinCore(rid, job);
        int coreLv = shenBinCore.getCoreLv();
        CShenBinHole cShenBinHole = shenBinHoleSysCache.getCShenBinHoleTemplate_jobCoreHole(job, coreLv, place);
        Asserts.notNull(cShenBinHole, ErrorCode.SHENBIN_HOLE_TEMPLATE_ERROR.getValue(), String.format("神兵孔位模板为null,job:{%s},place:{%s}", job, place));
        ShenBinEquip shenBinEquip = shenBinService.getShenBinEquip(rid, job, place);
        Asserts.isTrue(shenBinEquip.getSysId() <= 0, ErrorCode.SHENBIN_EQUIP_ALREADY.getValue(),
                String.format("神兵已经装备,rid:{%s},job:{%s},place:{%s}", rid, job, place));
        int sb_id = cShenBinHole.getSb_id();//当前孔位装备
        // 从背包中扣减一个装备道具
        ImmutableThing cost = ImmutableThing.of(sb_id, 1);
        thingService.cost(rid, cost, GameEvent.SHENBIN_EQUIP_SB);//先从背包扣除装备
        //设置数据
        shenBinEquip.setSysId(sb_id);
        shenBinService.updateShenBinEquip(shenBinEquip);
        //发送消息
        CrusadeGroupShenBinGMsg.GResShenBinEquip.Builder builder = CrusadeGroupShenBinGMsg.GResShenBinEquip.newBuilder();
        builder.setHoleData(PbUtil.buildShenBinEquip(shenBinEquip));
        builder.setFighting(getShenBinFighting_job(rid, job));//神兵战力
        playerContext.write(CmdCode._75603, builder.build());
    }

    /**
     * 核心升级
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._75604)
    public void shenBinCoreUp(PlayerContext playerContext, CrusadeGroupShenBinGMsg.GReqShenBinCoreUp msg) {
        long rid = playerContext.getId();
        int job = msg.getJob();
        int heroJobMax = systemSysCache.getHeroJobMax();//英雄职业最大值
        Asserts.isTrue(job >= 1 && job <= heroJobMax, ErrorCode.SHENBIN_CORE_PARAM_ERROR.getValue(),
                String.format("神兵核心升级参数错误job:{%s}", job));
        ShenBinCore shenBinCore = shenBinService.getRoleShenBinCore(rid, job);
        int coreLv = shenBinCore.getCoreLv();
        CShenBinCore cShenBinCore = shenBinCoreSysCache.getCShenBinCoreTemplate_jobCore(job, coreLv);//当前核心模板
        Asserts.notNull(cShenBinCore, ErrorCode.SHENBIN_CORE_TEMPLATE_ERROR.getValue(), String.format("核心升级,神兵核心模板为null,job:{%s},coreLv:{%s}", job, coreLv));
        CShenBinCore cShenBinCore_next = shenBinCoreSysCache.getCShenBinCoreTemplate_jobCore(job, coreLv + 1);//下一级核心模板
        Asserts.notNull(cShenBinCore_next, ErrorCode.SHENBIN_CORE_TEMPLATE_ERROR.getValue(), String.format("核心升级,神兵核心 下一级模板为null,job:{%s},coreLv:{%s}", job, coreLv));
        List<CShenBinHole> cShenBinHoles = shenBinHoleSysCache.getCShenBinHoleTemplates_jobCore(job, coreLv);
        Asserts.notNull(cShenBinHoles, ErrorCode.SHENBIN_HOLE_TEMPLATE_ERROR.getValue(), String.format("核心升级,神兵孔位模板为null,job:{%s},coreLv:{%s}", job, coreLv));
        //判断孔位是否已经装满
        for (CShenBinHole cShenBinHole : cShenBinHoles) {
            int place = cShenBinHole.getHole();
            ShenBinEquip shenBinEquip = shenBinService.getShenBinEquip(rid, job, place);
            if (shenBinEquip.getSysId() <= 0) {
                Asserts.isTrue(false, ErrorCode.SHENBIN_CORE_EQUIP_ERROR.getValue(),
                        String.format("神兵装备没有装满,不能升级,rid:{%s},job:{%s},coreLv:{%s},place:{%s}", rid, job, coreLv, place));
                return;
            }
        }
        //讨伐团职级等级判断******************************************
        int teamlv_need = cShenBinCore_next.getTeamlv();//需要的等级，拿升级后的职级需求
//        Occupation occupation = occupationService.getOccupation(rid);
        RoleCrusadeGroup roleCrusadeGroup = groupService.getRoleCrusadeGroup(rid);
        Asserts.isTrue(roleCrusadeGroup.getKnighthoodId() >= teamlv_need, ErrorCode.SHENBIN_CORE_OCCUPATION_NO.getValue(),
                String.format("神兵核心升级,职级不达标,rid:{%s},occupation:{%s},coreLv:{%s}", rid, roleCrusadeGroup.getKnighthoodId(), coreLv + 1));
        //核心升级，升级核心，重置孔位装备
        shenBinCore.setCoreLv(coreLv + 1);
        shenBinService.updateRoleShenBinCore(shenBinCore);
        //发送消息
        shenBinService.resetShenBinEquip(rid, job);
        CrusadeGroupShenBinGMsg.GResShenBinCoreUp.Builder builder = CrusadeGroupShenBinGMsg.GResShenBinCoreUp.newBuilder();
        CrusadeGroupShenBinGMsg.PSShenBinInfo.Builder shenBinInfo = CrusadeGroupShenBinGMsg.PSShenBinInfo.newBuilder();//1
        shenBinInfo.setJob(job);
        shenBinInfo.setCoreLv(shenBinCore.getCoreLv());
        CrusadeGroupShenBinGMsg.PSShenBinEquipData.Builder hEquips = CrusadeGroupShenBinGMsg.PSShenBinEquipData.newBuilder();//2
        hEquips.setJob(job);
        List<ShenBinEquip> list = shenBinService.getShenBinEquips(rid, job);
        for (ShenBinEquip equip : list) {
            // 没有按装备的部位进行排序
            hEquips.addEquipList(PbUtil.buildShenBinEquip(equip));
        }
        shenBinInfo.setEquipData(hEquips.build());
        shenBinInfo.setFighting(getShenBinFighting_job(rid, job));//神兵战力
        builder.setShenBinInfo(shenBinInfo);
        playerContext.write(CmdCode._75604, builder.build());
        //核心升级事件
        eventBus.post(ShenBinCoreUpEvent.of(playerContext.getId(), shenBinService.getShenBinJobCores(rid)));
    }

    /**
     * 神兵分解
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._75605)
    public void shenBinResolve(PlayerContext playerContext, CrusadeGroupShenBinGMsg.GReqShenBinResolve msg) {
        long rid = playerContext.getId();
        int sbId = msg.getEquipType();
        long resolveNum = msg.getEquipNum();
        Asserts.isTrue(resolveNum > 0, ErrorCode.SHENBIN_RESOLVE_PARAM_ERROR.getValue(), String.format("神兵分解,参数错误,rid:{%s},resolveNum:{%s}", rid, resolveNum));
        CShenBin cShenBin = shenBinSysCache.getCShenBinTemplate(sbId);
        Asserts.notNull(cShenBin, ErrorCode.SHENBIN_TEMPLATE_ERROR.getValue(), String.format("神兵分解,神兵模板为null,sbId:{%s}", sbId));
        int quality = cShenBin.getQuality();//当前要合成的神兵品质
        CShenBinResolve cShenBinResolve = shenBinResolveSysCache.getById(quality);
        Asserts.notNull(cShenBinResolve, ErrorCode.SHENBIN_RESOLVE_TEMPLATE_ERROR.getValue(), String.format("神兵分解模板为null,sbId:{%s}", sbId));
        //检查神兵背包分解神兵是否足够
        long bagNum = thingService.getCount(rid, sbId);//当前背包数量
        Asserts.isTrue(bagNum >= resolveNum, ErrorCode.SHENBIN_RESOLVE_NUM_NOT_ENOUGH.getValue(), String.format("神兵分解,背包数量不够,rid:{%s},resolveNum:{%s},bagNum:{%s}", rid, resolveNum, bagNum));
        List<ImmutableThing> compose_item_result = new ArrayList<>();//需要消耗的道具集合
        Map<Integer, Long> templateNeedMap = new HashMap<>();
        templateNeedMap.put(sbId, 1l);//当前需要解析的神兵
        //解析出当前神兵能转化的材料道具
        for (int i = 0; i < quality; i++) {
            Map<Integer, Long> templateNeedMap_ = new HashMap<>();
            for (Map.Entry<Integer, Long> entry : templateNeedMap.entrySet()) {
                int shenBinId = entry.getKey();//神兵id
                long num = entry.getValue();//需要解析的神兵数量
                CShenBin template = shenBinSysCache.getCShenBinTemplate(shenBinId);
                ImmutableList<ImmutableThing> compose_sb_temp = template.getCompose_sb();//需要消耗的神兵集合
                if (CollectionUtil.isEmpty(compose_sb_temp)) {//只需要消耗道具将
                    ImmutableList<ImmutableThing> compose_item_temp = template.getCompose_item();
                    for (int n = 0; n < num; n++) {//需要解析多少神兵，就需要多少材料
                        compose_item_result.addAll(compose_item_temp);
                    }
                    continue;
                }
                //检查当前背包消耗神兵是否足够
                for (ImmutableThing thing : compose_sb_temp) {
                    int thingType = thing.getItem_type();//消耗的神兵id
                    long needNum = thing.getItem_num();//解析1个神兵需要消耗的数量
                    long needAllNum = needNum * num;//解析多个神兵需要消耗的数量
                    long nowNum = templateNeedMap_.getOrDefault(thingType, 0l);
                    templateNeedMap_.put(thingType, nowNum + needAllNum);
                }
            }
            templateNeedMap = templateNeedMap_;//将数据赋值给计算集合继续查找
        }
        if (CollectionUtil.isEmpty(compose_item_result)) {
            Asserts.isTrue(false, ErrorCode.SHENBIN_RESOLVE_ITEM_ERROR.getValue(),
                    String.format("神兵分解错误,找不到解析的道具材料,sbId:{%s}", sbId));
        }

        //增加材料，扣除神兵道具
        // 从背包中扣减装备道具
        ImmutableThing cost = ImmutableThing.of(sbId, resolveNum);
        thingService.cost(rid, cost, GameEvent.SHENBIN_RESOLVE_SB);//先从背包扣除装备
        //增加材料
        List<ImmutableThing> compose_item_result_ = ImmutableThingUtil.mergeThing(compose_item_result);//合并道具
        //增加倍数（分解多个神兵）
        List<ImmutableThing> compose_item_result_2 = ImmutableThingUtil.multiplyThing(compose_item_result_, (int) resolveNum);
        float percentNum = cShenBinResolve.getPercent() / 100f;
        //根据比例添加材料
        List<ImmutableThing> compose_item_result_new = ImmutableThingUtil.multiplyThing(compose_item_result_2, percentNum);
        thingService.add(rid, compose_item_result_new, GameEvent.SHENBIN_RESOLVE_ITEM, NoticeType.NORMAL);
        //发送消息
        CrusadeGroupShenBinGMsg.GResShenBinResolve.Builder builder = CrusadeGroupShenBinGMsg.GResShenBinResolve.newBuilder();
        playerContext.write(CmdCode._75605, builder.build());
    }


    /**
     * 获取玩家神兵道具信息
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._75615)
    public void roleShenBinInfo(PlayerContext playerContext, CrusadeGroupShenBinGMsg.GReqRoleShenBinInfo msg) {
        long rid = playerContext.getId();
        RoleCrusadeGroup roleCrusadeGroup = groupService.getRoleCrusadeGroup(rid);
        CrusadeGroupShenBinGMsg.GResRoleShenBinInfo.Builder builder = CrusadeGroupShenBinGMsg.GResRoleShenBinInfo.newBuilder();
        //神兵精华
        if (roleCrusadeGroup.getForceNature() > 0) {
            CrusadeGroupShenBinGMsg.PSRoleShenBinInfo.Builder shenBinInfo_jh = CrusadeGroupShenBinGMsg.PSRoleShenBinInfo.newBuilder();//
            shenBinInfo_jh.setItemType(ItemType.SHENBIN_ESSENCE);
            shenBinInfo_jh.setItemNum(roleCrusadeGroup.getForceNature());
            builder.addRoleShenBins(shenBinInfo_jh);
        }
        //神兵
        for (Map.Entry<Integer, Long> entry : roleCrusadeGroup.getShenBinMap().entrySet()) {//根据职业区分
            CrusadeGroupShenBinGMsg.PSRoleShenBinInfo.Builder shenBinInfo = CrusadeGroupShenBinGMsg.PSRoleShenBinInfo.newBuilder();//
            shenBinInfo.setItemType(entry.getKey());
            shenBinInfo.setItemNum(entry.getValue());
            builder.addRoleShenBins(shenBinInfo);
        }
        playerContext.write(CmdCode._75615, builder.build());
    }


    /**
     * 神兵精华、boss伤害排行
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._75616)
    public void crusadeGroupRank(PlayerContext playerContext, CrusadeGroupRankGMsg.GReqCrusadeGroupRank msg) {
        long rid = playerContext.getId();
        int type = msg.getType();//1:神兵精华  2:boss伤害
        int cgId = msg.getCgId();//讨伐团id（当前玩家讨伐团id）
        CrusadeGroupRankGMsg.GResCrusadeGroupRank.Builder builder = CrusadeGroupRankGMsg.GResCrusadeGroupRank.newBuilder();
        if (type == 1) {
            builder.setSelf(crossCGItemRankService.selfRank(cgId));
            builder.addAllRanks(crossCGItemRankService.showRanks(100));
        } else if (type == 2) {
            builder.setSelf(crossCGHurtRankService.selfRank(cgId));
            builder.addAllRanks(crossCGHurtRankService.showRanks(100));
        }
        builder.setType(type);
        playerContext.write(CmdCode._75616, builder.build());
    }


    /**
     * 神兵精华、boss伤害排行（团员）
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._75617)
    public void crusadeGroupPRank(PlayerContext playerContext, CrusadeGroupRankGMsg.GReqCrusadeGroupPRank msg) {
        long rid = playerContext.getId();
        int type = msg.getType();//1:神兵精华  2:boss伤害
        int cgId = msg.getCgId();//讨伐团id
        CrusadeGroupRankGMsg.GResCrusadeGroupPRank.Builder builder = CrusadeGroupRankGMsg.GResCrusadeGroupPRank.newBuilder();
        if (type == 1) {
            builder.setSelf(crossCGItemPRankService.selfRank(cgId, playerContext.getId()));
            builder.addAllRanks(crossCGItemPRankService.showRanks(cgId, 100));
        } else if (type == 2) {
            builder.setSelf(crossCGHurtPRankService.selfRank(cgId, playerContext.getId()));
            builder.addAllRanks(crossCGHurtPRankService.showRanks(cgId, 100));
        }
        builder.setType(type);
        playerContext.write(CmdCode._75617, builder.build());
    }


    /**
     * 神兵战力
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._75618)
    public void shenBinFighting(PlayerContext playerContext, CrusadeGroupShenBinGMsg.GReqShenBinFighting msg) {
        long rid = playerContext.getId();
        int job = msg.getJob();//职业
        int heroJobMax = systemSysCache.getHeroJobMax();//英雄职业最大值
        Asserts.isTrue(job >= 1 && job <= heroJobMax, ErrorCode.WRONG_PARAMETERS.getValue(),
                String.format("获取神兵战力 参数不对job:{%s}", job));
        int fighting = getShenBinFighting_job(rid, job);
        CrusadeGroupShenBinGMsg.GResShenBinFighting.Builder builder = CrusadeGroupShenBinGMsg.GResShenBinFighting.newBuilder();
        builder.setFighting(fighting);
        playerContext.write(CmdCode._75618, builder.build());
    }

    //神兵战力
    private int getShenBinFighting_job(long rid, int job) {
//        List<Long> heroIds = heroLineUpService.getHeroLineUp_typeAndJob(rid, job, LineUpType.CRUSADE_GROUP);
        RoleCrusadeGroup roleCrusadeGroup = groupService.getRoleCrusadeGroup(rid);
        Map<Integer, CrusadeGroupHero> heroes = roleCrusadeGroup.getHeroes();//当前上阵英雄
        List<Long> heroIds = new ArrayList<>();
        for (Map.Entry<Integer, CrusadeGroupHero> entry : heroes.entrySet()) {
            CrusadeGroupHero crusadeGroupHero = entry.getValue();
            long heroId = crusadeGroupHero.getHeroId();
            if (heroId <= 0) {
                continue;
            }
            Hero hero = heroService.getHero(rid, heroId);
            if (hero == null) {
                continue;
            }
            CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getType());
            if (cHeroType.getOccupation() != job) {
                continue;
            }
            heroIds.add(heroId);
        }
        int fighting = 0;
        if (!heroIds.isEmpty()) {
            //long rId, List<Long> heroIds, Faction faction, ModuleType filterType
            BattlerDo battlerDo = battleHelper.queryPlayerBattler(rid, heroIds, Faction.ATTACKER, ModuleType.CRUSADE_GROUP);
            fighting = battlerDo.getFighting();
        }
        return fighting;
    }


    /**
     * 分享坐标
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._75619)
    public void shareCityPosit(PlayerContext playerContext, CrusadeGroupShenBinGMsg.GReqShareCityPosit msg) {
        long rid = playerContext.getId();
        int group_id = msg.getGroupId();
        ChatType chatType = ChatType.CROSS_CRUGROUP_CHAT;
        Asserts.isTrue(chatType.isShareSeason(), ErrorCode.SHENBIN_POSITE_NOT.getValue(), "讨伐团坐标不允许分享到此频道");
        RoleCrusadeGroup roleCrusadeGroup = groupService.getRoleCrusadeGroup(rid);
        Asserts.isTrue(roleCrusadeGroup.isRegistration(), ErrorCode.SHENBIN_NO_CG.getValue(), "未加入讨伐团，不可分享到此频道");

        CNotice cNotice = noticeSysCache.getOrThrow(chatType.getSeasonNoticeIdx());

        CCrusadeGroupMap cCrusadeGroupMap = crusadeGroupMapSysCache.getMap(group_id);
        Asserts.notNull(cCrusadeGroupMap, ErrorCode.CONFIG_NOT_EXISTS.getValue(), String.format("讨伐团地图数据不存在,group_id:{%s}", group_id));
        CCrusadeGroupBuild cCrusadeGroupBuild = crusadeGroupBuildSysCache.getBuild(cCrusadeGroupMap.getArea_level(), cCrusadeGroupMap.getBuilding_level(), cCrusadeGroupMap.getFight_type());
        Asserts.notNull(cCrusadeGroupBuild, ErrorCode.CONFIG_NOT_EXISTS.getValue(), String.format("讨伐团地图建筑数据不存在,Area_level:{%s},BuildingLevel:{%s},TerritoryType:{%s}",
                cCrusadeGroupMap.getArea_level(), cCrusadeGroupMap.getBuilding_level(), cCrusadeGroupMap.getFight_type()));
        //编缉参数
        List<String> paramList = new ArrayList<>();
        CLanguage language = languageSysCache.getByKey(cCrusadeGroupBuild.getName());
        String str1 = languageHelper.getLanguageBy(language);
        paramList.add(str1);//名字
        String str2 = "(" + cCrusadeGroupMap.getX() + "," + cCrusadeGroupMap.getY() + ")";
        paramList.add(str2);//坐标字符
        paramList.add(String.valueOf(group_id));//建筑id
        //发送聊天信息
        String finalChat = mailService.formatParamStr(cNotice.getChat_lang(), cNotice.getParam(), paramList);
        //组装广播参数
        List<String> paramList2 = new ArrayList<>();
        paramList2.add(String.valueOf(group_id));
        //再将group_id放入参数
        ErrorCode errorCode = chatService.send(chatType, finalChat, playerContext.getId(), 0, true, cNotice.getIdx(), paramList2);
        if (errorCode != ErrorCode.NO_ERROR) {
            playerContext.writeError(errorCode);
        }
    }
}
