/**
 *
 */
package com.ayjs.mxzg.gameserver.module.backpack.handler;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

import com.ayjs.mxzg.config.excel.cache.*;
import com.ayjs.mxzg.config.excel.entity.*;
import com.ayjs.mxzg.gameserver.module.backpack.decomposition.ThingDecompositionService;
import com.ayjs.mxzg.gameserver.module.backpack.service.processor.ThingType;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroMagicWand;
import com.ayjs.mxzg.gameserver.module.recharge.event.VirtualRechargeEvent;
import com.ayjs.mxzg.gameserver.module.recharge.service.RechargeService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.EquipmentType;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.domain.BackPack;
import com.ayjs.mxzg.gameserver.module.backpack.event.CombinePieceHeroEvent;
import com.ayjs.mxzg.gameserver.module.backpack.event.MakeEquipEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.BackPackService;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.backpack.use.ThingUse;
import com.ayjs.mxzg.gameserver.module.backpack.use.ThingUseService;
import com.ayjs.mxzg.gameserver.module.backpack.use.ThingUseType;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.recharge.domain.RoleRecharge;
import com.ayjs.mxzg.gameserver.module.recharge.service.RoleRechargeService;
import com.ayjs.mxzg.gameserver.module.role.constant.EntryType;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleVipService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.BackPackGMsg;
import com.ayjs.mxzg.protocol.BackPackGMsg.GReqRechargeCardUse;
import com.ayjs.mxzg.protocol.BackPackGMsg.GReqBackPackList;
import com.ayjs.mxzg.protocol.BackPackGMsg.GReqMakeEquip;
import com.ayjs.mxzg.protocol.BackPackGMsg.GReqOneKeyMakeEquip;
import com.ayjs.mxzg.protocol.BackPackGMsg.GReqOpenBoxReward;
import com.ayjs.mxzg.protocol.BackPackGMsg.GResBackPackList;
import com.ayjs.mxzg.protocol.BackPackGMsg.GResMakeEquip;
import com.ayjs.mxzg.protocol.BackPackGMsg.GResOneKeyMakeEquip;
import com.ayjs.mxzg.protocol.BackPackGMsg.GResOpenBoxReward;
import com.ayjs.mxzg.protocol.BackPackGMsg.ResBackPackItem;
import com.ayjs.mxzg.protocol.ObjectGMsg.PSBackpackData;
import com.ayjs.mxzg.template.constant.ErrorCode;

/**
 * @author YY
 *
 */
@Slf4j
@Controller
public class BackPackHandler extends ProtocolHandler {

    @Autowired
    private BackPackService backPackService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private EquipmenttypeSysCache equipmenttypeSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private RoleVipService roleVipService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private ItemSysCache itemSysCache;
    @Autowired
    private ElitePiecesSysCache elitePiecesSysCache;
    @Autowired
    private SelfSelectGiftSysCache selfSelectGiftSysCache;
    @Autowired
    private ThingUseService thingUseService;
    @Autowired
    private RoleRechargeService roleRechargeService;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private DecompositionSysCache decompositionSysCache;
    @Autowired
    private ThingDecompositionService thingDecompositionService;
    @Autowired
    private BuyGemSysCache buyGemSysCache;
    @Autowired
    private RechargeService rechargeService;

    // 合成装备的数量
    public final static int COMPOSE_EQUIPMENT_NUMBER = 3;

    @CMD(id = CmdCode._5001)
    public void getBackPackList(PlayerContext playerContext, GReqBackPackList msg) {
        List<BackPack> backList = backPackService.getBagList(playerContext.getId());
        GResBackPackList.Builder builder = GResBackPackList.newBuilder();
        for (BackPack item : backList) {
            if (item.getNum() <= 0) {
                continue;
            }
            ResBackPackItem.Builder thing = ResBackPackItem.newBuilder();
            thing.setItemId(item.getId());
            thing.setItemType(item.getItemId());
            thing.setNum(item.getNum());
            builder.addList(thing.build());
        }
        playerContext.write(CmdCode._5001, builder.build());
    }

    @CMD(id = CmdCode._5004, entry = EntryType.MAIN_SMITH_SHOP)
    public void makeEquip(PlayerContext playerContext, GReqMakeEquip msg) {
        Asserts.isTrue(msg.getMakeCount() > 0,
                ErrorCode.ERROR_PARAM.getValue(), () -> "msg.getMakeCount() less than 0 :" + msg.getMakeCount());

        CEquipmenttype newEquipType = equipmenttypeSysCache.getOrThrow(msg.getEquipType());

        List<ImmutableThing> oriCostList = newEquipType.getNeed_equipment();

        Asserts.isTrue(!oriCostList.isEmpty(), ErrorCode.BAG_COST_ERROR.getValue(),
                () -> String.format("equipment %s getNeed_equipment:%s is empty",
                        msg.getEquipType(), newEquipType.getNeed_equipment()));

        List<ImmutableThing> costList = new ArrayList<>();
        costList.addAll(oriCostList);
        costList.add(ImmutableThing.of(ItemType.IT_GOLD, newEquipType.getNeed_gold(), 0));

        List<ImmutableThing> finalCostList = ImmutableThingUtil.multiplyThing(costList, msg.getMakeCount());
        thingService.cost(playerContext.getId(), finalCostList, GameEvent.MAKE_EQUIP);

        // 达成合成要求
        ImmutableThing newEquip = ImmutableThing.of(newEquipType.getEquipment_type(), msg.getMakeCount(), 0);
        Rewards rewardList = thingService.add(playerContext.getId(), newEquip, GameEvent.MAKE_EQUIP, NoticeType.SLIENT);

        GResMakeEquip.Builder builder = GResMakeEquip.newBuilder();
        Map<Integer, Integer> equipMap = new HashMap<>();
        for (ImmutableThing reward : rewardList.getThingSet().asList()) {
            builder.addEquip(PbUtil.buildReward(reward));
            equipMap.put(reward.getItem_type(), equipMap.getOrDefault(reward.getItem_type(), 0) + (int) reward.getItem_num());
        }
        playerContext.write(CmdCode._5004, builder.build());

        eventBus.post(MakeEquipEvent.of(playerContext.getId(), msg.getMakeCount(), equipMap));
    }

    @CMD(id = CmdCode._5005, entry = EntryType.MAIN_SMITH_SHOP)
    public void makeAllEquip(PlayerContext playerContext, GReqOneKeyMakeEquip msg) {

        Role role = roleService.getOrThrow(playerContext.getId());
        RoleRecharge roleRecharge = roleRechargeService.getRoleRecharge(playerContext.getId());
        Asserts.isTrue(role.getLevel() >= systemSysCache.getEquipmentComposeQuicklyLevel() || roleRecharge.getTotalRecharge() > 0,
                ErrorCode.MAKE_ALL_UNCONDITION.getValue(), "还没有达到一键合成装备的要求");

        EquipmentType equipmentType = EquipmentType.of(msg.getEquipType());
        Asserts.notNull(equipmentType, ErrorCode.ERROR_PARAM.getValue(), () -> "EquipType error:" + msg.getEquipType());

        List<CEquipmenttype> equipmentTypeList = equipmenttypeSysCache.getEquipmentTypes(msg.getEquipType());
        Asserts.isTrue(Objects.nonNull(equipmentTypeList) && !equipmentTypeList.isEmpty(),
                ErrorCode.ERROR_PARAM.getValue(),
                () -> "equipmentTypeList is null or empty:" + msg.getEquipType());


        Map<Integer, PSBackpackData.Builder> itemMap = new LinkedHashMap<>();

        // 最终需要展示的结果
        List<ImmutableThing> resultList = new ArrayList<>();
        int makeCount = 0;

        Map<Integer, Integer> equipMap = new HashMap<>();

        for (CEquipmenttype type : equipmentTypeList) {

            CEquipmenttype currType = equipmenttypeSysCache.getOrThrow(type.getEquipment_type());
            List<ImmutableThing> costList = currType.getNeed_equipment();
            if (Objects.isNull(costList) || costList.isEmpty()) {
                continue;
            }
            // 计算金币能合几次
            long needGold = currType.getNeed_gold();
            long goldNumber = role.getGold() / needGold;
            // gold not enough
            if (goldNumber <= 0) {
                break;
            }
            // 计算道具能合几次
            int equipmentNumber = 0;
            for (; equipmentNumber <= goldNumber; equipmentNumber++) {
                List<ImmutableThing> tempCostList = ImmutableThingUtil.multiplyThing(costList, equipmentNumber + 1);

                if (!thingService.enough(role.getId(), tempCostList)) {
                    break;
                }
            }
            // 得到和合并几次
            int composeNumber = (int) Math.min(equipmentNumber, goldNumber);
            if (composeNumber <= 0) {
                continue;
            }
            // 组织扣除数据
            List<ImmutableThing> realCostList = ImmutableThingUtil.multiplyThing(costList, composeNumber);
            realCostList.add(ImmutableThing.of(ItemType.IT_GOLD, needGold * composeNumber));
            thingService.cost(role.getId(), realCostList, GameEvent.MAKE_ALL_EQUIP);

            ImmutableThing newEquip = ImmutableThing.of(currType.getEquipment_type(), composeNumber);
            Rewards rewardList = thingService.add(role.getId(), newEquip, GameEvent.MAKE_ALL_EQUIP, NoticeType.SLIENT);

            rewardList.getThingSet().asList().forEach(equip -> {
                equipMap.put(equip.getItem_type(), equipMap.getOrDefault(equip.getItem_type(), 0) + (int) equip.getItem_num());
            });

            resultList.addAll(rewardList.getThingSet().asList());

            resultList.addAll(realCostList.stream().map(thing ->
                    ImmutableThing.of(thing.getItem_type(), -thing.getItem_num())).collect(Collectors.toList()));

            makeCount += composeNumber;
        }
        resultList = ImmutableThingUtil.mergeThing(resultList).stream()
                .filter(thing -> thing.getItem_num() > 0).collect(Collectors.toList());

        for (ImmutableThing reward : resultList) {
            PSBackpackData.Builder eleBuilder = itemMap.get(reward.getItem_type());
            if (eleBuilder == null) {
                eleBuilder = PSBackpackData.newBuilder();
                eleBuilder.setType(reward.getItem_type());
                itemMap.put(reward.getItem_type(), eleBuilder);
            }
            eleBuilder.setNum(eleBuilder.getNum() + reward.getItem_num());
        }

        GResOneKeyMakeEquip.Builder builder = GResOneKeyMakeEquip.newBuilder();
        for (PSBackpackData.Builder ele : itemMap.values()) {
            builder.addEquip(ele.build());
        }
        playerContext.write(CmdCode._5005, builder.build());

        eventBus.post(MakeEquipEvent.of(role.getId(), makeCount, equipMap));
    }

    @CMD(id = CmdCode._5006)
    public void openBox(PlayerContext playerContext, GReqOpenBoxReward msg) {

        Asserts.isTrue(msg.getUseNum() > 0, ErrorCode.BAG_BOX_OPEN.getValue(),
                () -> "use number error:" + msg.getUseNum());

        CItem cItem = itemSysCache.getOrThrow(msg.getItemType());
        Asserts.isTrue(cItem.getUse_type() == 1, ErrorCode.BAG_BOX_OPEN_ERROR.getValue(),
                "道具类型错误，itemType:" + msg.getItemType());

        ThingUseType thingUseType = ThingUseType.of(1);
        ThingUse user = thingUseService.getUser(thingUseType);
        Rewards result = user.use(playerContext.getId(), cItem, msg.getUseNum(), GameEvent.OPEN_BOX);

//        CItemBoxChance cItemBoxChance = itemBoxChanceSysCache.getOrThrow(cItem.getUse_value());
//
//        Role role = roleService.getOrThrow(playerContext.getId());
//
//        ImmutableThing cost = ImmutableThing.of(msg.getItemType(), msg.getUseNum(), 0);
//
//        List<ImmutableThing> result = new ArrayList<>();
//        for (int i = 0; i < msg.getUseNum(); i++) {
//            List<ImmutableThing> reward = cItemBoxChance.getItem();
//            ImmutableThing randomReward = DropUtil.randomDrop(reward);
//            if (randomReward != null) {
//                result.add(randomReward);
//            }
//        }
//
//        Asserts.isTrue(!result.isEmpty(), ErrorCode.CONFIG_DATA_ERROR.getValue(),
//                () -> "randomReward is null:" + msg.getItemType());
//
//        thingService.cost(role.getId(), cost, GameEvent.OPEN_BOX);
//
//        result = ImmutableThingUtil.mergeThing(result);
//
//        thingService.add(role.getId(), result, GameEvent.OPEN_BOX, NoticeType.SLIENT);

        GResOpenBoxReward.Builder builder = GResOpenBoxReward.newBuilder();
        for (ImmutableThing reward : result.getThingSet().asList()) {
            PSBackpackData.Builder ele = PSBackpackData.newBuilder();
            ele.setType(reward.getItem_type());
            ele.setNum(reward.getItem_num());
            builder.addList(ele.build());
        }

        if (!result.getHeroMagicWands().isEmpty()) {
            for (HeroMagicWand heroMagicWand : result.getHeroMagicWands()) {
                PSBackpackData.Builder ele = PSBackpackData.newBuilder();
                ele.setType(heroMagicWand.getTypeId());
                ele.setId(heroMagicWand.getId());
                ele.setNum(1);
                builder.addList(ele.build());
            }
        }

        playerContext.write(CmdCode._5006, builder.build());
    }

    /*@CMD(id = CmdCode._5007)
    public void combinePieceHero(PlayerContext playerContext, GReqPieceReward msg) {

        Asserts.isTrue(msg.getUseNum() > 0, ErrorCode.BAG_HERO_PIECE_COMBINE.getValue(),
                () -> "use number error:" + msg.getUseNum());
        CHeropieces cHeropieces = heropiecesSysCache.getOrThrow(msg.getItemType());

        Role role = roleService.getOrThrow(playerContext.getId());

        this.getHeroMun(role, msg.getUseNum());

        ImmutableThing cost = ImmutableThing.of(cHeropieces.getType(), cHeropieces.getNeed_num() * msg.getUseNum(), 0);
        thingService.cost(role.getId(), cost, GameEvent.COMBINE_PIECE_HERO);

        GResPieceReward.Builder builder = GResPieceReward.newBuilder();
        int star4HeroNumber = 0;
        int star5HeroNumber = 0;
        // 0 按规则随机得到英雄，大于0得到指定英雄
        if (cHeropieces.getCombine_mode() == 0) {
            List<CLotteryWeight> randomList = new ArrayList<>();
            for (CHeroType cHeroType : heroTypeSysCache.getAll()) {
                if (cHeroType.getStar() != cHeropieces.getStar()) {
                    continue;
                }
                CLotteryWeight cLotteryWeight = lotteryWeightSysCache.getOrThrow(cHeroType.getType());

                if (cHeropieces.getElement() == 0) {
                    randomList.add(cLotteryWeight);
                } else {
                    if (cHeroType.getElem() == cHeropieces.getElement()) {
                        randomList.add(cLotteryWeight);
                    }
                }
            }


            List<ImmutableThing> reward = new ArrayList<>();
            for (int i = 0; i < msg.getUseNum(); i++) {
                CLotteryWeight randomResult = DropUtil.randomDrop(randomList, CLotteryWeight::getHero_type, CLotteryWeight::getChance_pieces);
                if (randomResult == null) {
                    continue;
                }
                reward.add(ImmutableThing.of(randomResult.getHero_type(), 1));

                if (randomResult.getStar() == 4) {
                    star4HeroNumber += 1;
                }
                if (randomResult.getStar() == 5) {
                    star5HeroNumber += 1;
                }
            }
            Rewards rewards = thingService.add(role.getId(), reward, GameEvent.COMBINE_PIECE_HERO, NoticeType.SLIENT);
            for (Hero newHero : rewards.getHeroes()) {
                builder.addList(heroService.serialize(newHero));
            }
        } else {
            CHeroType cHeroType = heroTypeSysCache.getOrThrow(cHeropieces.getCombine_mode());

            ImmutableThing reward = ImmutableThing.of(cHeroType.getType(), msg.getUseNum());
            Rewards rewards = thingService.add(role.getId(), reward, GameEvent.COMBINE_PIECE_HERO, NoticeType.SLIENT);

            for (Hero newHero : rewards.getHeroes()) {
                builder.addList(heroService.serialize(newHero));
                if (cHeroType.getStar() == 4) {
                    star4HeroNumber += 1;
                }
                if (cHeroType.getStar() == 5) {
                    star5HeroNumber += 1;
                }
            }
        }
        builder.setItemType(msg.getItemType());
        playerContext.write(CmdCode._5007, builder.build());

        eventBus.post(CombinePieceHeroEvent.of(role.getId(), msg.getUseNum(), star4HeroNumber, star5HeroNumber));
    }*/

    /**
     *  判断英雄数量是否超过上限
     * @param role
     * @param addMun
     */
    private void getHeroMun(Role role, int addMun) {
        List<Hero> heroList = heroService.getHeros(role.getId());

        // 当前英雄加上要增加的英雄量
        int heroNum = heroList.size() + addMun;

        Asserts.isTrue(heroNum <= roleVipService.getHeroCapacity(role.getId()), ErrorCode.HERO_NUM_LIMIT.getValue(),
                () -> String.format("max hero size:%s current hero size:%s use number:%s",
                        roleVipService.getHeroCapacity(role.getId()), heroList.size(), addMun));
    }

    /**
     * 精英英雄碎片合成
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._5008)
    public void combineElitePieceHero(PlayerContext playerContext, BackPackGMsg.GReqElitePieceHero msg) {
        BackPackGMsg.GResElitePieceHero.Builder builder = BackPackGMsg.GResElitePieceHero.newBuilder();

        Asserts.isTrue(msg.getNum() > 0, ErrorCode.BAG_HERO_PIECE_COMBINE.getValue(),
                () -> "use number error:" + msg.getNum());

        Role role = roleService.getOrThrow(playerContext.getId());
        //验证英雄数据
        this.getHeroMun(role, msg.getNum());

        CItem cItem = itemSysCache.getOrThrow(msg.getItemType());
        Asserts.isTrue(cItem.getUse_type() == 4, ErrorCode.ERROR_PARAM.getValue(), () -> "ItemType error :" + msg.getItemType());

        ImmutableThing cost = ImmutableThing.of(msg.getItemType(), cItem.getUse_value() * msg.getNum());
        thingService.cost(playerContext.getId(), cost, GameEvent.COMBINE_ELITE_PIECE_HERO);

        List<CElitePieces> elitePiecesList =
                elitePiecesSysCache.getAll().stream().filter(config -> config.getItem_type() == msg.getItemType())
                        .collect(Collectors.toList());

        List<ImmutableThing> rewardList = new ArrayList<>();
        for (int i = 0; i < msg.getNum(); i++) {
            CElitePieces cElitePieces = DropUtil.randomDrop(elitePiecesList, CElitePieces::getIdx, CElitePieces::getWeight);
            if (cElitePieces == null) {
                continue;
            }
            ImmutableThing reward = ImmutableThing.of(cElitePieces.getHero_id(), 1);
            rewardList.add(reward);
        }
        Rewards rewards = thingService.add(role.getId(), rewardList, GameEvent.COMBINE_PIECE_HERO, NoticeType.SLIENT);

        for (Hero hero : rewards.getHeroes()) {
            builder.addList(heroService.buildHero(hero));
        }

        builder.setItemType(msg.getItemType());
        playerContext.write(CmdCode._5008, builder.build());

        eventBus.post(CombinePieceHeroEvent.of(role.getId(), msg.getNum(), 0, msg.getNum()));
    }

    @CMD(id = CmdCode._5009)
    public void selfSelectGift(PlayerContext playerContext, BackPackGMsg.GReqSelfSelectGift req) {
        long rid = playerContext.getId();
        int itemId = req.getItemId();

        CItem itemConfig = itemSysCache.getOrThrow(itemId);
        CSelfSelectGift config = selfSelectGiftSysCache.getOrThrow(req.getIdx());
        Asserts.isTrue(itemConfig.getUse_type() == 3 && itemConfig.getUse_value() == config.getType() , ErrorCode.ITEM_USE_TYPE_ERROR.getValue(),
                String.format("道具id:{%s},use_type:{%s}", itemId, itemConfig.getUse_type()));

        ImmutableThing thing = config.getReward().get(0);
        if(thing.getItem_type() != req.getItemType()){
            log.info("玩家{}使用自选礼包道具id{}跟主键id{}不匹配", rid, req.getItemType(), req.getIdx());
            config = selfSelectGiftSysCache.getByOrThrow(itemConfig.getUse_value(), req.getItemType());
            log.error("玩家{}自选礼包itemId:{}跟主键id:{}不匹配，自动匹配为目标礼包id:{}", rid, req.getItemType(), req.getIdx(), config.getIdx());
        }

        thingService.cost(rid, ImmutableThing.of(itemId, 1), GameEvent.SELF_SELECT_GIFT);

        thingService.add(rid, config.getReward(), GameEvent.SELF_SELECT_GIFT);

        BackPackGMsg.GResSelfSelectGift.Builder builder = BackPackGMsg.GResSelfSelectGift.newBuilder();
        playerContext.write(CmdCode._5009, builder.build());
    }

    /**
     * 分解道具
     *
     */
    @CMD(id = CmdCode._5011)
    public void decompositionThing(PlayerContext playerContext, BackPackGMsg.GReqDecompositionThing msg) {
        CItem cItem = itemSysCache.getOrThrow(msg.getItem().getItemType());
        Asserts.isTrue(cItem.getDecomposition() == 1, ErrorCode.BAG_NOT_DECOMPOSITION.getValue(), String.format("该道具不分解{%s}", msg.getItem().getItemType()));

        CDecompositionItem cDecompositionItem = decompositionSysCache.getOrThrow(msg.getItem().getItemType());

        ThingType thingType = ThingType.of(cItem.getType());
        thingDecompositionService.decompositionThing(playerContext.getId(), thingType, msg.getItem(), GameEvent.ITEM_DECOMPOSITION);

        thingService.add(playerContext.getId(), ImmutableThingUtil.multiplyThing(cDecompositionItem.getReward(), msg.getItem().getNum()), GameEvent.ITEM_DECOMPOSITION);

        BackPackGMsg.GResDecompositionThing.Builder builder = BackPackGMsg.GResDecompositionThing.newBuilder();
        playerContext.write(CmdCode._5011, builder.build());
    }

    /**
     * 充值卡使用
     */
    @CMD(id = CmdCode._5012)
    public void reqRechargeCardUse(PlayerContext playerContext, GReqRechargeCardUse msg) {
        long rid = playerContext.getId();
        int itemId = msg.getItemId();
        CItem cItem = itemSysCache.getOrThrow(itemId);

        int productId = cItem.getUse_value();
        CBuyGem cBuyGem = buyGemSysCache.getOrThrow(productId);

        Role role = roleService.getOrThrow(rid);
        Asserts.isTrue(role.getLevel() >= cBuyGem.getLevel(), ErrorCode.HERO_LEVEL_NOT_ENOUGH.getValue(),
                String.format("英雄等级{%s}不足{%s}", role.getLevel(), cBuyGem.getLevel()));
        Asserts.isTrue(rechargeService.isCanBuy(rid, cBuyGem), ErrorCode.RECHARGE_CANT_BUY.getValue(),
                String.format("玩家{%s}无法再购买{%s}", rid, productId));

        boolean success = rechargeService.buyGoodsSuccess(rid, productId, cBuyGem.getRmb(), true);
        Asserts.isTrue(success, ErrorCode.RECHARGE_CARD_BUY_FAIL.getValue(), String.format("玩家{%s}购买{%s}失败", rid, productId));
        eventBus.post(VirtualRechargeEvent.of(rid, productId, 1, 1));

        // 使用
        Asserts.isTrue(cItem.getUse_type() == ThingUseType.RECHARGE_CARD.getValue(),
                ErrorCode.RECHARGE_CARD_USE_ERROR.getValue(), String.format("道具{%s}类型不是充值卡", itemId));

        ThingUse user = thingUseService.getUser(ThingUseType.RECHARGE_CARD);
        user.use(rid, cItem, 1, GameEvent.RECHARGE_CARD_USE);

        playerContext.write(CmdCode._5012, BackPackGMsg.GResRechargeCardUse.getDefaultInstance());
    }
}
