package com.ayjs.mxzg.gameserver.module.shop.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.ShopTeamArenaSysCache;
import com.ayjs.mxzg.config.excel.cache.countryWar.ShopCountryWarSysCache;
import com.ayjs.mxzg.config.excel.cache.magicTower.MagicTowerDailyShopSysCache;
import com.ayjs.mxzg.config.excel.cache.magicTower.MagicTowerLifeShopSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopChampionSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopChristmasSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopDaySysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopDifferentWorldSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopFashionSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopFloatingIslandsSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopFragmentSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopGodequipmentSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopHeroSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopLadderSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopMakeEggSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopRunesSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopSuperHeroSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopSuperRankSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopTalentSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopTimeTowerSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopZsjtSysCashe;
import com.ayjs.mxzg.config.excel.cache.shop.ShopadventureSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopclanSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopcontrolSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopmarketSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShoppromotionSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopprophecySysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShoppvpnormalSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopsacrificeSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopstallSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopwishpoolSysCache;
import com.ayjs.mxzg.config.excel.entity.magicTower.CMagicTowerDailyShop;
import com.ayjs.mxzg.config.excel.entity.magicTower.CMagicTowerLifeShop;
import com.ayjs.mxzg.config.excel.entity.shop.CShopcontrol;
import com.ayjs.mxzg.config.excel.entity.shop.CShopstall;
import com.ayjs.mxzg.config.excel.entity.shop.IShop;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingSet;
import com.ayjs.mxzg.gameserver.module.magicTower.domain.MagicTower;
import com.ayjs.mxzg.gameserver.module.magicTower.service.MagicTowerService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleVipService;
import com.ayjs.mxzg.gameserver.module.shop.constant.ShopType;
import com.ayjs.mxzg.gameserver.module.shop.domain.Shop;
import com.ayjs.mxzg.gameserver.module.shop.event.ShopBuyEvent;
import com.ayjs.mxzg.gameserver.module.shop.service.ShopService;
import com.ayjs.mxzg.protocol.ShopGMsg;
import com.ayjs.mxzg.protocol.ShopGMsg.GReqGetFreeNum;
import com.ayjs.mxzg.protocol.ShopGMsg.GResGetFreeNum;
import com.ayjs.mxzg.protocol.ShopGMsg.GResShopBuy;
import com.ayjs.mxzg.protocol.ShopGMsg.GResShopRefresh;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ShopHandler extends ProtocolHandler {

    @Autowired
    private ShopcontrolSysCache shopcontrolSysCache;
    @Autowired
    private ShopService shopService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private ShopmarketSysCache shopmarketSysCache;
    @Autowired
    private ShopwishpoolSysCache shopwishpoolSysCache;
    @Autowired
    private ShopprophecySysCache shopprophecySysCache;
    @Autowired
    private ShopsacrificeSysCache shopsacrificeSysCache;
    @Autowired
    private ShoppvpnormalSysCache shoppvpnormalSysCache;
    @Autowired
    private ShopclanSysCache shopclanSysCache;
    @Autowired
    private ShopadventureSysCache shopadventureSysCache;
    @Autowired
    private ShopstallSysCache shopstallSysCache;
    @Autowired
    private ShoppromotionSysCache shoppromotionSysCache;
    @Autowired
    private ShopFragmentSysCache shopFragmentSysCache;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private RoleVipService roleVipService;
    @Autowired
    private ShopHeroSysCache shopHeroSysCache;
    @Autowired
    private ShopRunesSysCache shopRunesSysCache;
    @Autowired
    private ShopLadderSysCache shopLadderSysCache;
    @Autowired
    private ShopTalentSysCache shopTalentSysCache;
    @Autowired
    private ShopFashionSysCache shopFashionSysCache;
    @Autowired
    private ShopGodequipmentSysCache shopGodequipmentSysCache;
    @Autowired
    private ShopChampionSysCache shopChampionSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ShopTeamArenaSysCache shopTeamArenaSysCache;
    @Autowired
    private ShopSuperHeroSysCache shopSuperHeroSysCache;
    @Autowired
    private ShopDaySysCache shopDaySysCache;
    @Autowired
    private ShopSuperRankSysCache shopSuperRankSysCache;
    @Autowired
    private ShopFloatingIslandsSysCache shopFloatingIslandsSysCache;
    @Autowired
    private ShopTimeTowerSysCache shopTimeTowerSysCache;
    @Autowired
    private ShopZsjtSysCashe shopZsjtSysCashe;
    @Autowired
    private ShopDifferentWorldSysCache shopDifferentWorldSysCache;
    @Autowired
    private ShopChristmasSysCache shopChristmasSysCache;
    @Autowired
    private ShopMakeEggSysCache shopMakeEggSysCache;
    @Autowired
    private ShopCountryWarSysCache shopCountryWarSysCache;
    @Autowired
    private MagicTowerLifeShopSysCache magicTowerLifeShopSysCache;
    @Autowired
    private MagicTowerDailyShopSysCache magicTowerDailyShopSysCache;
    @Autowired
    private MagicTowerService magicTowerService;

    @CMD(id = CmdCode._50001)
    public void shopRefresh(PlayerContext playerContext, ShopGMsg.GReqShopRefresh msg) {

        CShopcontrol cShopcontrol = shopcontrolSysCache.getOrThrow(msg.getType());

        if (cShopcontrol.getIdx() == ShopType.HERO.getValue()) {
            Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.MEI_RI_LI_BAO),
                    ErrorCode.PROMOTION_NOT_RUNNING.getValue(), "英雄商店不在活动期间，不能刷新");
        }

        Asserts.isTrue(cShopcontrol.getManual_refresh_mode() == 1,
                ErrorCode.SHOP_CAN_NOT_REFRESH.getValue(), () -> "商店不能刷新type:" + msg.getType());

        ShopType shopType = ShopType.of(msg.getType());
        Asserts.isTrue(shopType != null,
                ErrorCode.SHOP_NOT_EXIST.getValue(), () -> "商店不存在type:" + msg.getType());

        Shop shop = shopService.getShop(playerContext.getId(), shopType);
        GResShopRefresh.Builder builder = GResShopRefresh.newBuilder();
        if (shop.getCurrFreeNum() > 0) {
            if (shop.getCurrFreeNum() == cShopcontrol.getMax_refresh_count()) {
                shop.setLastFreeTime(DateTimeUtil.currentSecond());
            }
            shop.setCurrFreeNum(shop.getCurrFreeNum() - 1);
            builder.setOperat(0);
        } else {
            Asserts.isTrue(shop.getRefreshNum() < roleVipService.getShopMaxRefreshNum(playerContext.getId(), msg.getType()),
                    ErrorCode.SHOP_MAX_REFRESH.getValue(), "商店刷新次数已达上限");
            builder.setOperat(1);
            // 扣除消耗
            thingService.cost(playerContext.getId(), cShopcontrol.getCharge_item_cost(), GameEvent.SHOP_REFRESH);
            shop.setRefreshNum(shop.getRefreshNum() + 1);
        }

        shopService.refreshShopItem(shop);

        builder.setType(msg.getType());
        builder.setRefreshNum(shop.getRefreshNum());
        builder.setLastFreeTime(shop.getLastFreeTime());
        builder.setFreeCount(shop.getCurrFreeNum());
        playerContext.write(CmdCode._50001, builder.build());

        shopService.sendOneShopData0(shop);
    }

    @CMD(id = CmdCode._50002)
    public void shopBuy(PlayerContext playerContext, ShopGMsg.GReqShopBuy msg) {
        ShopType shopType = ShopType.of(msg.getType());
        Asserts.isTrue(shopType != null,
                ErrorCode.SHOP_NOT_EXIST.getValue(), () -> "商店不存在type:" + msg.getType());

        if (msg.getType() == ShopType.HERO.getValue()) {
            Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.MEI_RI_LI_BAO),
                    ErrorCode.PROMOTION_NOT_RUNNING.getValue(), "英雄商店不在活动期间，不能购买英雄商店的商品");
        }
        // 购买数量
        int buyTimes = msg.getBuyTimes();
        Asserts.isTrue(buyTimes > 0, ErrorCode.ERROR_PARAM.getValue(), () -> "less 0 buyTimes:" + buyTimes);

        long rid = playerContext.getId();

        int shopIdx = msg.getIdx();

        Shop shop = shopService.getShop(rid, shopType);

        Integer buyNumber = shop.getItems().get(shopIdx);
        Asserts.isTrue(buyNumber != null,
                ErrorCode.SHOP_GOOD_MISS.getValue(), () -> "你的商店中并未出现该商品:" + shopIdx);

        Role role = roleService.getOrThrow(playerContext.getId());

        MagicTower magicTower = magicTowerService.load(rid);
        int sumStar = magicTower.getSumStar();
        IShop iShop = null;
        if (shopType == ShopType.MARKET) {
            iShop = shopmarketSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.WISH_POOL) {
            // 许愿池商店
            iShop = shopwishpoolSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.PROPHECY) {
            // 先知商店
            iShop = shopprophecySysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.SACRIFICE) {
            // 祭坛商店
            iShop = shopsacrificeSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.PVP_NORMAL) {
            // 竞技场商店
            iShop = shoppvpnormalSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.CLAN) {
            // 公会商店
            iShop = shopclanSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.ADVENTURE) {
            // 试炼商店
            iShop = shopadventureSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.STALL) {
            // TaskCountChangeEvent黑市商店
            iShop = shopstallSysCache.getOrThrow(shopIdx);
            CShopstall cShopstall = shopstallSysCache.getOrThrow(shopIdx);
            Asserts.isTrue(role.getClergyLevel() >= cShopstall.getClergy_require(), ErrorCode.SHOP_STALL_CLERGY.getValue(),
                    "神职等级不够，无法购买该商品");
        } else if (shopType == ShopType.PROMOTION) {
            // 秘境商店
            iShop = shoppromotionSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.HERO) {
            //英雄商店
            iShop = shopHeroSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.RUNES) {
            //精灵商店
            iShop = shopRunesSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.LADDER) {
            //跨服天梯积分商店
            iShop = shopLadderSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.FRAGMENT) {
            //先知碎片商店
            iShop = shopFragmentSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.TALENT) {
            //天赋商店
            iShop = shopTalentSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.FASHION) {
            //皮肤商店
            iShop = shopFashionSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.GODEQUIPMENT) {
            // 神装商店
            iShop = shopGodequipmentSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.CHAMPION) {
            //跨服冠军赛商店
            iShop = shopChampionSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.TEAM_ARENA) {
            //组队竞技场商店
            iShop = shopTeamArenaSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.SUPER_HERO) {
            //超级英雄商店
            iShop = shopSuperHeroSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.DAY) {
            //直购商店
            iShop = shopDaySysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.STAGE_MATCH) {
            //直购商店
            iShop = shopSuperRankSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.FLOATING_ISLANDS) {
            //直购商店
            iShop = shopFloatingIslandsSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.TIME_TOWER) {
            //时空魔塔
            iShop = shopTimeTowerSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.ZSJT) {
            //诸神祭坛商店
            iShop = shopZsjtSysCashe.getOrThrow(shopIdx);
        } else if (shopType == ShopType.DIFFERENT_WORLD) {
            //异界商店
            iShop = shopDifferentWorldSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.CHRISTMAS) {
            //圣诞
            iShop = shopChristmasSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.MAKE_EGG) {
            //制作彩蛋
            iShop = shopMakeEggSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.COUNTRY_WAR) {
            //军工商城
            iShop = shopCountryWarSysCache.getOrThrow(shopIdx);
        } else if (shopType == ShopType.MAGIC_TOWER_DAILY) {
            iShop = magicTowerDailyShopSysCache.getOrThrow(shopIdx);
            CMagicTowerDailyShop config = magicTowerDailyShopSysCache.getOrThrow(shopIdx);
            Asserts.isTrue(sumStar >= config.getStar(), ErrorCode.MAGIC_TOWER_STAR_NO_ENOUGH.getValue(),
                String.format("当前总星数{%s}小于所需星数{%s}", sumStar, config.getStar()));
        } else if (shopType == ShopType.MAGIC_TOWER_LIFT) {
            iShop = magicTowerLifeShopSysCache.getOrThrow(shopIdx);
            CMagicTowerLifeShop config = magicTowerLifeShopSysCache.getOrThrow(shopIdx);
            Asserts.isTrue(sumStar >= config.getStar(), ErrorCode.MAGIC_TOWER_STAR_NO_ENOUGH.getValue(),
                    String.format("当前总星数{%s}小于所需星数{%s}", sumStar, config.getStar()));
        }

        Asserts.isTrue(iShop != null,
                ErrorCode.SHOP_NOT_EXIST.getValue(), () -> "商店不存在type:" + msg.getType());

        int finalBuyLimit = iShop.getBuy_limit();
        int finalBuyNumber = buyNumber;
        Asserts.isTrue(iShop.getBuy_limit() <= 0 || buyNumber + buyTimes <= iShop.getBuy_limit(), ErrorCode.SHOP_BUY_TIMES_NOT_ENOUGH.getValue(),
                () -> "buy_limit:" + finalBuyLimit + " buyNumber:" + finalBuyNumber + " buytimes:" + buyTimes);

        List<ImmutableThing> costThing = ImmutableThingUtil.multiplyThing(iShop.getNeed_item(), buyTimes);
        ThingSet cost = thingService.cost(playerContext.getId(), costThing, GameEvent.MARKET_SHOP_GET);

        shop.getItems().put(shopIdx, buyNumber + buyTimes);
        shopService.updateShop(shop);

        List<ImmutableThing> addThing = ImmutableThingUtil.multiplyThing(iShop.getItem_type(), buyTimes);
        Rewards rewards = thingService.add(playerContext.getId(), addThing, GameEvent.MARKET_SHOP_GET);

        GResShopBuy.Builder resBuilder = GResShopBuy.newBuilder();
        resBuilder.setType(shopType.getValue());
        resBuilder.setIdx(shopIdx);
        resBuilder.setBuyNum(buyNumber + buyTimes);
        playerContext.write(CmdCode._50002, resBuilder.build());

        eventBus.post(ShopBuyEvent.of(rid, shopType, shopIdx, cost.asList(), rewards.getThingSet().asList(), buyTimes));
    }

    @CMD(id = CmdCode._50005)
    public void getFreeNum(PlayerContext playerContext, GReqGetFreeNum msg) {
        ShopType shopType = ShopType.of(msg.getType());
        Asserts.isTrue(shopType != null,
                ErrorCode.SHOP_NOT_EXIST.getValue(), () -> "商店不存在type:" + msg.getType());

        Shop shop = shopService.getShop(playerContext.getId(), shopType);

        GResGetFreeNum.Builder builder = GResGetFreeNum.newBuilder();
        builder.setType(msg.getType());
        builder.setFreeRefreshNum(shop.getCurrFreeNum());
        builder.setLastFreeTime(shop.getLastFreeTime());
        playerContext.write(CmdCode._50005, builder.build());
    }
}
