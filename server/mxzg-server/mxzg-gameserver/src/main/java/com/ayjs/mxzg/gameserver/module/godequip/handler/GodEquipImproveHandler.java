/**
 *
 */
package com.ayjs.mxzg.gameserver.module.godequip.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.config.excel.cache.god.GodEquipmentRandomAbilitySysCache;
import com.ayjs.mxzg.config.excel.cache.god.GodEquipmentRandomAbilityTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.god.GodEquipmentRareSysCache;
import com.ayjs.mxzg.config.excel.cache.god.GodEquipmentSysCache;
import com.ayjs.mxzg.config.excel.constant.GodEquipConst;
import com.ayjs.mxzg.config.excel.entity.god.CGodEquipment;
import com.ayjs.mxzg.config.excel.entity.god.CGodEquipmentRandomAbilityType;
import com.ayjs.mxzg.config.excel.entity.god.CGodEquipmentRare;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.GodAttr;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.godequip.domain.GodEquip;
import com.ayjs.mxzg.gameserver.module.godequip.event.GodEquipImproveEvent;
import com.ayjs.mxzg.gameserver.module.godequip.event.GodEquipUpStarEvent;
import com.ayjs.mxzg.gameserver.module.godequip.service.GodEquipService;
import com.ayjs.mxzg.protocol.GodEquipGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;

import java.util.ArrayList;
import java.util.List;

/**
 * @author
 *
 */
@Controller
public class GodEquipImproveHandler extends ProtocolHandler {

    @Autowired
    private GodEquipService godEquipService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private GodEquipmentSysCache godEquipmentSysCache;
    @Autowired
    private GodEquipmentRareSysCache godEquipmentRareSysCache;
    @Autowired
    private GodEquipmentRandomAbilitySysCache godEquipmentRandomAbilitySysCache;
    @Autowired
    private GodEquipmentRandomAbilityTypeSysCache godEquipmentRandomAbilityTypeSysCache;
    @Autowired
    private EventBus eventBus;

    /**
     * 神装洗炼
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._58010)
    public void washEquip(PlayerContext playerContext, GodEquipGMsg.GReqWashGodEquip msg) {

        GodEquip godEquip = godEquipService.getEquip(playerContext.getId(), msg.getEquipId());
        Asserts.isTrue(godEquip != null, ErrorCode.GODEQUIP_NOT_EXIST.getValue(), String.format("该神装不存在{%s}:", msg.getEquipId()));

        //洗炼扣费
        CGodEquipment cGodEquipment = godEquipmentSysCache.getOrThrow(godEquip.getSysId());
        CGodEquipmentRare cGodEquipmentRare = godEquipmentRareSysCache.getOrThrow(cGodEquipment.getRare());

        Asserts.isTrue(cGodEquipmentRare.getRandom_ability_num() > 0, ErrorCode.GODEQUIP_NOT_WASH.getValue(),
                "该品质神装无法洗炼");

        if (cGodEquipmentRare.getRandom_ability_num() > 0 &&
                cGodEquipmentRare.getRandom_ability_num() == msg.getLockSortList().size()) {
            boolean f = false;
            for (GodAttr godAttr : godEquip.getAttrs()) {
                int maxLevel = godEquipmentRandomAbilitySysCache.abilityMaxLevel(cGodEquipment.getPlace(), cGodEquipment.getStar(), godAttr.getSysId());
                if (godAttr.getLevel() < maxLevel) {
                    f = true;
                    break;
                }
            }
            Asserts.isTrue(f, ErrorCode.GODEQUIP_WASH_ATTR_MAX_LEVEL.getValue(), "锁定属性已达最大值，不可锁定洗炼");
        }

        thingService.cost(playerContext.getId(), cGodEquipmentRare.getWash_cost(), GameEvent.GOD_EQUIP_WISH);

        //属性上锁扣费
        if (GodEquipConst.lockCost.get(msg.getLockSortList().size()) != null) {
            thingService.cost(playerContext.getId(), GodEquipConst.lockCost.get(msg.getLockSortList().size()), GameEvent.GOD_EQUIP_WISH_LOCK_COST);
        }

        //获得已存在的属性列表
        List<Integer> attrList = new ArrayList<>();
        for (GodAttr godAttr : godEquip.getAttrs()) {
            if (msg.getLockSortList().contains(godAttr.getSort())) {
                attrList.add(godAttr.getSysId());
            }
        }

        List<GodAttr> washAbilityList = new ArrayList<>();
        godEquip.getAttrs().forEach(godAttr -> {

            //解锁或上锁
            godAttr.setLock(msg.getLockSortList().contains(godAttr.getSort()) ? 1 : 0);

            //随机到的属性
            int abilityType = godAttr.getLock() == 1 ? godAttr.getSysId() : this.dropAttr(godEquip, attrList);

            //添加到验证重复属性列表
            attrList.add(abilityType);

            //获取洗炼属性等级
            int washLevel = godEquip.getWashNum() + cGodEquipmentRare.getRandom_ability_start_level();

            //获取新的洗炼属性
            GodAttr newGodAttr = godEquipmentRandomAbilitySysCache.washAbility(cGodEquipment.getPlace(),
                    cGodEquipment.getStar(), abilityType, godAttr, washLevel);
            washAbilityList.add(newGodAttr);

        });

        //替换洗炼中的属性
        godEquip.getWashAttrs().clear();
        godEquip.getWashAttrs().addAll(washAbilityList);
        godEquip.setWashNum(godEquip.getWashNum() + 1);
        godEquipService.updateEquip(godEquip);

        GodEquipGMsg.GResWashGodEquip.Builder builder = GodEquipGMsg.GResWashGodEquip.newBuilder();
        builder.setEquip(godEquipService.buildGodEquip(godEquip));
        playerContext.write(CmdCode._58010, builder.build());
    }

    private int dropAttr(GodEquip godEquip, List<Integer> attrList) {

        int abilityType = 0;
        boolean f = true;

        while (f) {
            //获取洗炼的随机属性类型
            CGodEquipmentRandomAbilityType cGodEquipmentRandomAbilityType =
                    DropUtil.randomDrop(godEquipmentRandomAbilityTypeSysCache.getPlaceAbility(godEquip.getPlace()));

            abilityType = cGodEquipmentRandomAbilityType.getAbility_type();

            f = attrList.contains(abilityType);
        }

        return abilityType;
    }

    /**
     * 洗炼保存
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._58011)
    public void saveWashEquip(PlayerContext playerContext, GodEquipGMsg.GReqSaveWashGodEquip msg) {

        GodEquip godEquip = godEquipService.getEquip(playerContext.getId(), msg.getEquipId());
        Asserts.isTrue(godEquip.getWashAttrs().size() > 0, ErrorCode.GODEQUIP_WASH_ABILITY_SAVE.getValue(),
                "该新装无洗炼属性。");

        List<GodAttr> oldAbility = godEquip.getAttrs();

        godEquip.getAttrs().clear();
        godEquip.getAttrs().addAll(godEquip.getWashAttrs());

        godEquip.getWashAttrs().clear();
        godEquipService.updateEquip(godEquip);

        GodEquipGMsg.GResSaveWashGodEquip.Builder builder = GodEquipGMsg.GResSaveWashGodEquip.newBuilder();
        builder.setEquip(godEquipService.buildGodEquip(godEquip));
        playerContext.write(CmdCode._58011, builder.build());

        eventBus.post(GodEquipImproveEvent.of(playerContext.getId(), godEquip.getId(), godEquip.getHeroId(), oldAbility, godEquip.getAttrs(), GameEvent.GOD_EQUIP_WISH));
    }

    /**
     * 神装升星
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._58012)
    public void godEquipUpStar(PlayerContext playerContext, GodEquipGMsg.GReqGodEquipUpStar msg) {

        Asserts.isTrue(msg.getGodEquipListCount() == 3, ErrorCode.GODEQUIP_UP_STAR_COUNT.getValue(),
                "神装升星要求合成量不足");

        GodEquip godEquipInfo = godEquipService.getEquip(playerContext.getId(), msg.getGodEquipListList().get(0));
        Asserts.isTrue(godEquipInfo != null, ErrorCode.GODEQUIP_NOT_EXIST.getValue(), String.format("该神装不存在{%s}:", msg.getGodEquipListList().get(0)));

        int godEquipType = godEquipInfo.getSysId();
        CGodEquipment cGodEquipment = godEquipmentSysCache.getOrThrow(godEquipType);
        Asserts.isTrue(cGodEquipment.getCombine_target() != 0, ErrorCode.GODEQUIP_UP_STAR_NOT_EXIST.getValue(),
                String.format("神装升星目标不存在，合成材料：%s", godEquipType));

        List<GodEquip> godEquipList = new ArrayList<>();
        for (long godEquipId : msg.getGodEquipListList()) {
            GodEquip godEquip = godEquipService.getEquip(playerContext.getId(), godEquipId);
            Asserts.isTrue(godEquip != null, ErrorCode.GODEQUIP_NOT_EXIST.getValue(), String.format("该神装不存在{%s}:", godEquipId));

            Asserts.isTrue(godEquip.getSysId() == godEquipType, ErrorCode.GODEQUIP_UP_STAR_TYPE.getValue(),
                    String.format("合成目标：%s,需求类型：%s,当前错误类型：%s", cGodEquipment.getCombine_target(), godEquipType, godEquip.getSysId()));

            Asserts.isTrue(godEquip.getHeroId() == 0, ErrorCode.GODEQUIP_WEARING.getValue(),
                    "该神装已经装备在英雄身上，不可用于升星");

            godEquipList.add(godEquip);
        }

        CGodEquipmentRare cGodEquipmentRare = godEquipmentRareSysCache.getOrThrow(cGodEquipment.getRare());
        Asserts.isTrue(cGodEquipmentRare.getRandom_ability_num() == msg.getAttrListList().size(), ErrorCode.GODEQUIP_UP_STAR_ATTR_NUM.getValue()
                , "继承的属性数量不正确");

        //继承的属性
        List<GodAttr> attrList = new ArrayList<>();
        List<Integer> attrTypeList = new ArrayList<>();
        for (GodEquipGMsg.PSGodEquipAttr psGodEquipAttr : msg.getAttrListList()) {

            GodEquip godEquip = godEquipService.getEquip(playerContext.getId(), psGodEquipAttr.getId());

            Asserts.isTrue(godEquipList.contains(godEquip), ErrorCode.GODEQUIP_NOT_EXIST.getValue(), "不可继承非升星材料的属性");

            GodAttr godAttr = null;
            for (GodAttr attr : godEquip.getAttrs()) {
                if (attr.getSort() == psGodEquipAttr.getSort()) {

                    Asserts.isTrue(!attrTypeList.contains(attr.getSysId()), ErrorCode.GODEQUIP_UP_STAR_ATTR.getValue(), "神装升星属性继承重复");

                    godAttr = attr;
                    attrTypeList.add(godAttr.getSysId());
                }
            }

            Asserts.notNull(godAttr, ErrorCode.GODEQUIP_SORT_ATTR.getValue(), "该神装不存在此槽位号的属性");
            attrList.add(godAttr);
        }

        thingService.cost(playerContext.getId(), cGodEquipment.getUp_star_cost(), GameEvent.GOD_EQUIP_UP_STAR);

        //删除神装
        godEquipService.deleteEquips(godEquipList, GameEvent.GOD_EQUIP_UP_STAR);

        //添加神装
        GodEquip godEquip = this.addGodEquip(playerContext.getId(), cGodEquipment.getCombine_target(),
                attrList);

        GodEquipGMsg.GResGodEquipUpStar.Builder builder = GodEquipGMsg.GResGodEquipUpStar.newBuilder();
        builder.setEquip(godEquipService.buildGodEquip(godEquip));
        playerContext.write(CmdCode._58012, builder.build());

        eventBus.post(GodEquipUpStarEvent.of(playerContext.getId(), godEquip));
    }

    private GodEquip addGodEquip(long rid, int godEquipType, List<GodAttr> attrList) {
        CGodEquipment cGodEquipment = godEquipmentSysCache.getOrThrow(godEquipType);
        GodEquip godEquip = new GodEquip();
        godEquip.setHeroId(0);
        godEquip.setRid(rid);
        List<GodAttr> godAttrs = new ArrayList<>();
        int i = 1;
        for (GodAttr godAttr : attrList) {
            godAttr.setSort(i);
            godAttrs.add(godAttr);
            i++;
        }
        godEquip.setAttrs(godAttrs);
        godEquip.setWashAttrs(new ArrayList<>());
        godEquip.setPlace(cGodEquipment.getPlace());
        godEquip.setSysId(godEquipType);
        godEquipService.addEquip(godEquip, GameEvent.GOD_EQUIP_UP_STAR);
        return godEquip;
    }

    /**
     * 神装回收
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._58013)
    public void godEquipRecycle(PlayerContext playerContext, GodEquipGMsg.GReqGodEquipRecycle msg) {

        List<GodEquip> godEquipList = new ArrayList<>();
        List<ImmutableThing> rewardList = new ArrayList<>();
        for (long equipId : msg.getGodEquipsList()) {

            GodEquip godEquip = godEquipService.getEquip(playerContext.getId(), equipId);
            Asserts.notNull(godEquip, ErrorCode.GODEQUIP_NOT_EXIST.getValue(), "神装不存在");

            Asserts.isTrue(godEquip.getHeroId() == 0, ErrorCode.GODEQUIP_WEARING.getValue(),
                    "该神装已经装备在英雄身上，不可回收。");

            CGodEquipment cGodEquipment = godEquipmentSysCache.getOrThrow(godEquip.getSysId());
            rewardList.addAll(cGodEquipment.getRecover_reward());

            if (godEquip.getWashNum() > 0) {
                CGodEquipmentRare cGodEquipmentRare = godEquipmentRareSysCache.getOrThrow(cGodEquipment.getRare());
                rewardList.addAll(ImmutableThingUtil.multiplyThing(cGodEquipmentRare.getWash_cost(), godEquip.getWashNum()));
            }

            godEquipList.add(godEquip);
        }

        Asserts.isTrue(godEquipList.size() > 0, ErrorCode.GODEQUIP_RECYCLE.getValue(), "神装回收道具数量为0");

        godEquipService.deleteEquips(godEquipList, GameEvent.GOD_EQUIP_RECYCLE);

        rewardList = ImmutableThingUtil.mergeThing(rewardList);
        thingService.add(playerContext.getId(), rewardList, GameEvent.GOD_EQUIP_RECYCLE, NoticeType.NORMAL);

        GodEquipGMsg.GResGodEquipRecycle.Builder builder = GodEquipGMsg.GResGodEquipRecycle.newBuilder();
        playerContext.write(CmdCode._58013, builder.build());
    }

}
