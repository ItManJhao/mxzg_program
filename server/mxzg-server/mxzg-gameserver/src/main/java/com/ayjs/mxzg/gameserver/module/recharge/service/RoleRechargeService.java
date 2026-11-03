package com.ayjs.mxzg.gameserver.module.recharge.service;

import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.InternerPool;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.BuyGemSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion022DailyTotalRechargeSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.constant.StatesMoneyUnit;
import com.ayjs.mxzg.gameserver.module.recharge.dao.RoleRechargeDao;
import com.ayjs.mxzg.gameserver.module.recharge.domain.Recharge;
import com.ayjs.mxzg.gameserver.module.recharge.domain.RoleRecharge;
import com.ayjs.mxzg.gameserver.module.recharge.event.RechargeEvent;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.module.util.StringEncryptUtil;
import com.ayjs.mxzg.protocol.RechargeGMsg.GResShopRechargeCheck;
import com.ayjs.mxzg.template.constant.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * @description: 充值
 * @author: CWJ
 * @date: 2019/10/15 11:36
 */
@Slf4j
@Service
public class RoleRechargeService implements IRechargeBuyingService {

    @Autowired
    RoleRechargeDao roleRechargeDao;
    @Autowired
    EventBus eventBus;
    @Autowired
    ContextManager contextManager;
    @Autowired
    RoleService roleService;
    @Autowired
    Promotion022DailyTotalRechargeSysCache promotionDailyTotalRechargeSysCache;
    @Autowired
    ThingService thingService;
    @Autowired
    ServerParamService serverParamService;
    @Autowired
    BuyGemSysCache buyGemSysCache;
    @Autowired
    private RechargeService rechargeService;

    private final static String CHARGE_LOCK = "CHARGE_LOCK";
    // 游戏币充值标识
    private final static String GAME_COIN = "coin";

    /***
     * 充值数据记录
     * @param rid
     * @param money 分为单位
     * @param productId
     */
    public void recharge(long rid, int money, int productId, int gameCoin) {
        RoleRecharge roleRecharge = getRoleRecharge(rid);
        roleRecharge.setTotalRecharge(roleRecharge.getTotalRecharge() + money);
        roleRecharge.setDailyRecharge(roleRecharge.getDailyRecharge() + money);
        roleRecharge.setWeeklyRecharge(roleRecharge.getWeeklyRecharge() + money);
        if (!TimeDateUtil.isSameDay(roleRecharge.getRechargeTime(), TimeDateUtil.getCurrentTime())) {
            roleRecharge.setRechargeDays(roleRecharge.getRechargeDays() + 1);
        }
        roleRecharge.setRechargeTime(TimeDateUtil.getCurrentTime());

        if (contextManager.isOnline(rid)) {
            //玩家在线则推送充值更新
            GResShopRechargeCheck.Builder builder = GResShopRechargeCheck.newBuilder();
            builder.addList(productId);
            builder.setTotalCharge(roleRecharge.getTotalRecharge());
            builder.addAllBuyIdx(roleRecharge.getChargedInfo());
            contextManager.write(rid, CmdCode._30002, builder.build());
        } else {
            //玩家离线则记录还没有推送到的充值商品
            roleRecharge.getUntellRecharge().add(productId);
        }

        roleRechargeDao.update(roleRecharge);

        eventBus.post(RechargeEvent.of(rid, money, productId, gameCoin));
    }

    public RoleRecharge getRoleRecharge(long rid) {
        synchronized (InternerPool.intern(CHARGE_LOCK, rid)) {
            RoleRecharge roleRecharge = roleRechargeDao.get(rid);
            if (roleRecharge == null) {
                roleRecharge = new RoleRecharge();
                roleRecharge.setRid(rid);
                roleRecharge.setChargedInfo(new HashSet<>());
                roleRecharge.setDailyRechargeReward(new HashSet<>());
                roleRecharge.setUntellRecharge(new ArrayList<>());
                roleRechargeDao.add(roleRecharge);
            }
            if (!TimeDateUtil.isSameDay(roleRecharge.getRechargeTime(), TimeDateUtil.getCurrentTime())) {
                roleRecharge.setDailyRecharge(0);
                if (!TimeDateUtil.isSameWeek(roleRecharge.getRechargeTime(), TimeDateUtil.getCurrentTime())) {
                    roleRecharge.setWeeklyRecharge(0);
                }
                roleRechargeDao.update(roleRecharge);
            }
            return roleRecharge;
        }
    }

    public void update(RoleRecharge roleRecharge) {
        roleRechargeDao.update(roleRecharge);
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.NORMAL;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        return true;
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        RoleRecharge roleRecharge = getRoleRecharge(rid);
        List<ImmutableThing> rewards = new ArrayList<>(cBuyGem.getItem());
        if (!roleRecharge.getChargedInfo().contains(cBuyGem.getIdx())) {
            roleRecharge.getChargedInfo().add(cBuyGem.getIdx());
            this.update(roleRecharge);
            rewards.addAll(cBuyGem.getFirst_buy_reward());
        }
        rewards = ImmutableThingUtil.mergeThing(rewards);
        // 记录首充的id和时间戳，两个条件都符合才可，否则就是没有同步更新。
        if (roleRecharge.getFirstRechargeTime() == 0 && roleRecharge.getFirstRechargeId() == 0) {
            long currentTime = TimeDateUtil.getCurrentTime();
            roleRecharge.setFirstRechargeTime(currentTime);
            roleRecharge.setFirstRechargeId(cBuyGem.getIdx());
            this.update(roleRecharge);
        }
        if (isGm) {
            thingService.add(rid, rewards, GameEvent.GM_RECHARGE);
        } else {
            thingService.add(rid, rewards, GameEvent.RECHARGE);
        }
    }

    public Recharge createRecharge(Role role, CBuyGem cBuyGem, String cliExtraInfo) {
        Recharge recharge = new Recharge();
        recharge.setRid(role.getId());
        recharge.setServerId(role.getServerId());
        recharge.setProductType(0);
        recharge.setTime(TimeDateUtil.getCurrentTimeInt());
        recharge.setProductId(cBuyGem.getIdx());
        recharge.setProductCode(cBuyGem.getPlatformCode(role.getPlatform()));
        recharge.setGiveState(0);
        recharge.setPreMoney(cBuyGem.getRmb());
        recharge.setPayMoney(cBuyGem.getRmb());
        recharge.setCliExtraInfo(cliExtraInfo);
        recharge.setRoleLv(role.getLevel());
        recharge.setGameCoin(0);
        recharge.setExtraCameCoin(0);
        recharge.setStatesMoney(cBuyGem.getRmb());
        recharge.setStatesMoneyUnit(StatesMoneyUnit.RMB.getType());

        rechargeService.addRecharge(recharge);

        Map<String, Object> extraInfoMap = new HashMap<>();
        extraInfoMap.put("goods_id", cBuyGem.getIdx());
        extraInfoMap.put("level", role.getLevel());
        extraInfoMap.put("money", cBuyGem.getRmb());
        extraInfoMap.put("game_order_id", String.valueOf(recharge.getId()));
        extraInfoMap.put("role_id", String.valueOf(role.getId()));
        String extraInfo = GJsonUtils.toJson(extraInfoMap);
        recharge.setExtraInfo(StringEncryptUtil.simpleBase64Encryption(extraInfo));
        // 因为需要Recharge 生成的id所以上面先调用了插入数据。
        rechargeService.updateRecharge(recharge);

        return recharge;
    }

    public Recharge createThirdPartyRecharge(String platformOrderId, Map<String, String> extraDataMap) {
        String productType = ConvertUtils.toString(extraDataMap.getOrDefault("product_type", ""));
        long rid = ConvertUtils.toLong(extraDataMap.getOrDefault("role_id", ""));
        if (rid <= 0) {
            log.error("第三方充值参数错误 role_id:{}", rid);
            // GJsonUtils.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), "ROLE_ID_NOT_FOUND"))
            return null;
        }

        String currency = ConvertUtils.toString(extraDataMap.getOrDefault("currency", ""));

        StatesMoneyUnit statesMoneyUnit = StatesMoneyUnit.nameOf(currency);
        if (Objects.isNull(statesMoneyUnit)) {
            log.error("第三方充值充值货币单位错误 currency:{}", currency);
            //GJsonUtils.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), "CURRENCY_ERROR"))
            return null;
        }
        int statesMoney = ConvertUtils.toInt(extraDataMap.getOrDefault("money", ""));


        Role role = roleService.getOrThrow(rid);

        Recharge recharge = new Recharge();
        recharge.setRid(role.getId());
        recharge.setServerId(role.getServerId());
        recharge.setTime(TimeDateUtil.getCurrentTimeInt());
        recharge.setGiveState(0);
        recharge.setRoleLv(role.getLevel());
        recharge.setStatesMoney(statesMoney);// 付款地区的货币数量
        recharge.setStatesMoneyUnit(statesMoneyUnit.getType());// 付款地区的货币单位


        Map<String, Object> extraInfoMap = new HashMap<>();
        extraInfoMap.put("level", role.getLevel());
//        extraInfoMap.put("vip", role.getGoddessVip());
        extraInfoMap.put("role_id", String.valueOf(role.getId()));

        if (GAME_COIN.equals(productType)) { // 按游戏币发货
            int gameGold = ConvertUtils.toInt(extraDataMap.getOrDefault("game_gold", ""));
            int extraGameGold = ConvertUtils.toInt(extraDataMap.getOrDefault("extra_game_gold", ""));
            recharge.setProductType(1);//商品类型为：1游戏币充值
            recharge.setGameCoin(gameGold);//真实购买的游戏币
            recharge.setExtraCameCoin(extraGameGold);//赠送的游戏币

            double payUsd = ConvertUtils.toDouble(extraDataMap.getOrDefault("pay_usd", ""));
            int payUsdCent = (int) (payUsd * 100);
            recharge.setPreMoney(payUsdCent);// 实际支付的金额,兑换后的人民币，美金等
            recharge.setPayMoney(payUsdCent);
            extraInfoMap.put("goods_id", 0);// 没有对于的商品id
            extraInfoMap.put("money", payUsdCent);

        } else { // 按商品id发货
            int productId = ConvertUtils.toInt(extraDataMap.getOrDefault("product_id", ""));
            CBuyGem cBuyGem = buyGemSysCache.getOrThrow(productId);
            Asserts.notNull(cBuyGem, ErrorCode.BUY_GEM_NOT_FOUND.getValue(), productId + "");
            recharge.setProductType(0);
            recharge.setProductId(cBuyGem.getIdx());
            recharge.setProductCode(cBuyGem.getPlatformCode(role.getPlatform()));
            recharge.setPreMoney(cBuyGem.getRmb());
            recharge.setPayMoney(cBuyGem.getRmb());
            recharge.setGameCoin(0);
            recharge.setExtraCameCoin(0);
            recharge.setCliExtraInfo(platformOrderId);// 暂时放平台订单id
            extraInfoMap.put("goods_id", cBuyGem.getIdx());
            extraInfoMap.put("money", cBuyGem.getRmb());
        }

        rechargeService.addRecharge(recharge);

        extraInfoMap.put("game_order_id", String.valueOf(recharge.getId()));
        String extraInfo = GJsonUtils.toJson(extraInfoMap);
        recharge.setExtraInfo(StringEncryptUtil.simpleBase64Encryption(extraInfo));

        rechargeService.updateRecharge(recharge);
        return recharge;
    }

}
