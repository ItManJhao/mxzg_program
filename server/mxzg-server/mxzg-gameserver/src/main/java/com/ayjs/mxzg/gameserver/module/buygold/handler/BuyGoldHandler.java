package com.ayjs.mxzg.gameserver.module.buygold.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.BuyGoldCostSysCache;
import com.ayjs.mxzg.config.excel.cache.BuyGoldSysCache;
import com.ayjs.mxzg.config.excel.cache.GoddessVipSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGold;
import com.ayjs.mxzg.config.excel.entity.CBuyGoldCost;
import com.ayjs.mxzg.config.excel.entity.CGoddessVip;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.config.struct.ThingBonus;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.domain.RoleMission;
import com.ayjs.mxzg.gameserver.module.battle.service.RoleMissionService;
import com.ayjs.mxzg.gameserver.module.buygold.constant.BuyGoldType;
import com.ayjs.mxzg.gameserver.module.buygold.domain.BuyGold;
import com.ayjs.mxzg.gameserver.module.buygold.event.BuyGoldEvent;
import com.ayjs.mxzg.gameserver.module.buygold.service.BuyGoldService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PrivilegeEffectType;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion010PrivilegeGiftService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.BugGoldGMsg.GReqBuyGold;
import com.ayjs.mxzg.protocol.BugGoldGMsg.GReqBuyGoldLog;
import com.ayjs.mxzg.protocol.BugGoldGMsg.GResBuyGold;
import com.ayjs.mxzg.protocol.BugGoldGMsg.GResBuyGoldLog;
import com.ayjs.mxzg.protocol.BugGoldGMsg.PSBuyGoldData;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;


/**
 * 点金模块
 */
@Controller
public class BuyGoldHandler extends ProtocolHandler {
    @Autowired
    private BuyGoldService buyGoldService;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private BuyGoldCostSysCache buyGoldCostSysCache;
    @Autowired
    private BuyGoldSysCache buyGoldSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private RoleMissionService roleMissionService;
    @Autowired
    private GoddessVipSysCache goddessVipSysCache;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private Promotion010PrivilegeGiftService promotion010PrivilegeGiftService;

    @CMD(id = CmdCode._17000)
    public void buyGoldList(PlayerContext playerContext, GReqBuyGoldLog msg) {
        GResBuyGoldLog.Builder builder = GResBuyGoldLog.newBuilder();
        BuyGold buyGold = buyGoldService.getBuyGold(playerContext.getId());
        builder.setTime(LocalDateTimeUtil.toEpochSecond(buyGold.getNextRefreshTime()));
        if (promotionControlService.isPromotionRunning(PromotionType.DIAN_SHI_CHENG_JIN)) {
            builder.setStatus(1);
        } else {
            builder.setStatus(0);
        }
        Map<Integer, Integer> buyInfo = buyGold.getBuyInfo();
        for (Map.Entry<Integer, Integer> entry : buyInfo.entrySet()) {
            PSBuyGoldData.Builder model = PSBuyGoldData.newBuilder();
            model.setIdx(entry.getKey());
            model.setNum(entry.getValue());
            builder.addList(model.build());
        }
        playerContext.write(CmdCode._17000, builder.build());
    }

    /**
     * 购买点金礼包
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._17001)
    public void buyGold(PlayerContext playerContext, GReqBuyGold msg) {

        BuyGold buyGold = buyGoldService.getBuyGold(playerContext.getId());
        CBuyGoldCost cModel = buyGoldCostSysCache.getOrThrow(msg.getIdx());

        Map<Integer, Integer> buyInfoMap = buyGold.getBuyInfo();
        Integer buyNumber = buyInfoMap.get(msg.getIdx());

        Asserts.notNull(buyNumber, ErrorCode.BUY_GOLD_TYPE_NOT_EXISTENT.getValue(), () -> "idx is null" + msg.getIdx());

        BuyGoldType buyGoldType = BuyGoldType.of(msg.getIdx());
        Asserts.notNull(buyGoldType, ErrorCode.BUY_GOLD_TYPE_NOT_EXISTENT.getValue(), () -> "idx is null" + msg.getIdx());

        if (promotionControlService.isPromotionRunning(PromotionType.DIAN_SHI_CHENG_JIN)) {
            Asserts.isTrue(cModel.getPromotion_limit() > buyNumber,
                    ErrorCode.BUY_GOLD_NUM_NOT_ENOUGH.getValue(),
                    () -> "is promotion current buy number:" + buyNumber + " limit:" + cModel.getPromotion_limit());
        } else {
            Asserts.isTrue(cModel.getLimit() > buyNumber,
                    ErrorCode.BUY_GOLD_NUM_NOT_ENOUGH.getValue(),
                    () -> "current buy number:" + buyNumber + " limit:" + cModel.getLimit());
        }
        Role role = roleService.getOrThrow(playerContext.getId());
        // 判断是否免费
        if (cModel.getPrize() > 0) {
            ImmutableThing costThing = ImmutableThing.of(ItemType.IT_GEM, cModel.getPrize());
            thingService.cost(role.getId(), costThing, GameEvent.BUY_GOLD);
        }
        // 免费不要调用扣除方法
        RoleMission roleMission = roleMissionService.getRoleMission(role.getId());
        int chapterId = 1;
        if (roleMission.getChapterId() > 1) {
            chapterId = roleMission.getChapterId();
        }
        CBuyGold cBuyGold = buyGoldSysCache.getOrThrow(chapterId);

        long gold = 0;
        if (BuyGoldType.Free.equals(buyGoldType)) {
            gold = cBuyGold.getGold_1();
        } else if (BuyGoldType.Lower.equals(buyGoldType)) {
            gold = cBuyGold.getGold_2();
        } else if (BuyGoldType.Advanced.equals(buyGoldType)) {
            gold = cBuyGold.getGold_3();
        }

        List<ImmutableThing> rewardList = new ArrayList<>();
        rewardList.add(ImmutableThing.of(ItemType.IT_GOLD, gold));

        Map<Integer, ImmutableThing> baseRewardMap = ListMapUtil.listToMap(rewardList, ImmutableThing::getItem_type);

        if (role.getGoddessVip() > 0) {
            CGoddessVip goddessVip = goddessVipSysCache.getOrThrow(role.getGoddessVip());
            ThingService.addBonus(rewardList, baseRewardMap, goddessVip.getBuyGoldBonusList());
        }

        List<ThingBonus> privilegeBonus = promotion010PrivilegeGiftService.getPrivilegeBonus(role.getId(), PrivilegeEffectType.BUY_GOLD);
        ThingService.addBonus(rewardList, baseRewardMap, privilegeBonus, PrivilegeEffectType.BUY_GOLD);

        //修改点金次数
        buyInfoMap.put(msg.getIdx(), buyNumber + 1);
        buyGoldService.updateBuyGold(buyGold);

        //加道具
        rewardList = ImmutableThingUtil.mergeThing(rewardList);
        thingService.add(role.getId(), rewardList, GameEvent.BUY_GOLD, NoticeType.SLIENT);
        //
        GResBuyGold.Builder builder = GResBuyGold.newBuilder();
        builder.setGold(gold);
        builder.setIdx(msg.getIdx());
        builder.setGetRate(privilegeBonus.stream().mapToInt(ThingBonus::getBonus).sum());
        playerContext.write(CmdCode._17001, builder.build());
        eventBus.post(BuyGoldEvent.of(role.getId(), buyGoldType));
    }
}
