package com.ayjs.mxzg.gameserver.module.shop.service;


import cn.hutool.core.date.DateUtil;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.IDrop;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
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
import com.ayjs.mxzg.config.excel.entity.shop.CShopDifferentWorld;
import com.ayjs.mxzg.config.excel.entity.shop.CShopcontrol;
import com.ayjs.mxzg.config.excel.entity.shop.CShopmarket;
import com.ayjs.mxzg.config.excel.entity.shop.IShop;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleVipService;
import com.ayjs.mxzg.gameserver.module.shop.constant.ShopType;
import com.ayjs.mxzg.gameserver.module.shop.dao.ShopDao;
import com.ayjs.mxzg.gameserver.module.shop.domain.Shop;
import com.ayjs.mxzg.protocol.ShopGMsg.GResOneShopData;
import com.ayjs.mxzg.protocol.ShopGMsg.GResShopList;
import com.ayjs.mxzg.protocol.ShopGMsg.ResShopInfo;
import com.ayjs.mxzg.protocol.ShopGMsg.ResShopItem;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 *
 */
@Slf4j
@Service
public class ShopService {

    @Autowired
    private ShopDao shopDao;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private ShopcontrolSysCache shopcontrolSysCache;
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
    private ShopHeroSysCache shopHeroSysCache;
    @Autowired
    private ShopFragmentSysCache shopFragmentSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private RoleVipService roleVipService;
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

    /**
     * 获取店铺信息时会自动刷新需要刷新的商店
     *
     * @param rid
     * @param type
     * @return
     */
    public Shop getShop(long rid, ShopType type) {
        List<Shop> shopList = shopDao.getShops(rid);
        Optional<Shop> shopOpt = shopList.stream().filter(shop -> shop.getType() == type.getValue()).findFirst();

        Shop shop = shopOpt.orElse(null);
        if (Objects.isNull(shop)) {
            shop = new Shop();
            shop.setRid(rid);
            shop.setType(type.getValue());
            shop.setRefreshNum(0);
            shop.setItems(new HashMap<>());
            shopDao.add(shop);
            refreshShopItem(shop);
        }
        autoRefreshShop(shop);
        return shop;
    }

    public void updateShops(List<Shop> list) {
        shopDao.update(list);
    }

    public void updateShop(Shop shop) {
        shopDao.update(shop);
    }

    public void sendOneShopData(long rid, ShopType type) {
        Shop shop = getShop(rid, type);
        sendOneShopData0(shop);
    }

    public void sendOneShopData0(Shop shop) {
        GResOneShopData.Builder builder = GResOneShopData.newBuilder();
        builder.addList(toResShopData(shop));
        contextManager.write(shop.getRid(), CmdCode._50004, builder.build());
    }

    // 需要优化
    public void shopControl(long rid) {
        GResShopList.Builder builder = GResShopList.newBuilder();
        // 初始化在getShop里面，所有这里不能调用getShops
        for (ShopType shopType : ShopType.values()) {
            Shop shop = getShop(rid, shopType);
            builder.addList(toResShopData(shop));
        }
        contextManager.write(rid, CmdCode._50000, builder.build());
    }

    // TODO 需要优化
    private ResShopInfo toResShopData(Shop shop) {
        ResShopInfo.Builder shopInfo = ResShopInfo.newBuilder();
        try {

            Map<Integer, Integer> items = shop.getItems();


            CShopcontrol shopcontrol = shopcontrolSysCache.getOrThrow(shop.getType());
            shopInfo.setType(shop.getType());
            shopInfo.setChargeItemCost(GJsonUtils.toJson(shopcontrol.getCharge_item_cost()));

            int maxRefreshNum = roleVipService.getShopMaxRefreshNum(shop.getRid(), shop.getType());

            int refreshNum = shop.getRefreshNum();
            if (refreshNum >= maxRefreshNum) {
                shopInfo.setChargeRefreshNum(0);
            } else {
                int chargeRefreshNum = maxRefreshNum - refreshNum;
                shopInfo.setChargeRefreshNum(chargeRefreshNum);

                if (chargeRefreshNum > maxRefreshNum - shopcontrol.getDaily_free_refresh()) {
                    shopInfo.setChargeRefreshNum(maxRefreshNum);
                }
            }
            for (Map.Entry<Integer, Integer> entry : items.entrySet()) {
                if (Objects.isNull(entry.getKey()) || Objects.isNull(entry.getValue())) {
                    continue;
                }
                ResShopItem.Builder shopItem = ResShopItem.newBuilder();
                shopItem.setIdx(entry.getKey());
                shopItem.setBuyNum(entry.getValue());
                shopInfo.addItem(shopItem.build());
            }
            shopInfo.setCurrFreeNum(shop.getFreeRefreshNum());
            shopInfo.setFreeRefreshNum(shop.getCurrFreeNum());
            shopInfo.setLastFreeTime(shop.getLastFreeTime());
        } catch (Exception e) {
            log.error("toResShopData {}", shop.getType(), e);
            e.printStackTrace();
        }
        return shopInfo.build();
    }

    /**
     * 商店下次刷新时间
     *
     * @param refreshMode
     * @return
     */
    public int getNextRefreshTime(int refreshMode) {
        int time = 0;
        if (refreshMode == 1) {
            // 每天0点刷新
            time = DateTimeUtil.tomorrowBreak();
        } else if (refreshMode == 2) {
            // 下周一0点
            time = (int) (DateUtil.beginOfWeek(DateUtil.nextWeek()).getTime() / TimeDateUtil.ONESECOND);
        } else if (refreshMode == 3) {
            // 下月一号0点
            time = (int) (DateUtil.beginOfMonth(DateUtil.nextMonth()).getTime() / TimeDateUtil.ONESECOND);
        }
        return time;
    }

    /**
     * 系统自动刷新商店数据
     *
     * @param rid
     */
    public void autoRefreshShop(long rid) {
        // 重新刷新物品
        for (ShopType shopType : ShopType.values()) {
            Shop shop = getShop(rid, shopType);
            if (!shop.getItems().isEmpty()) {
                continue;
            }
            autoRefreshShop(shop);
            this.updateShop(shop);
        }
        shopControl(rid);
    }

    /**
     * 系统自动刷新
     *
     * @param shop
     */
    private void autoRefreshShop(Shop shop) {
        if (Objects.isNull(shop)) {
            return;
        }
        int now = DateTimeUtil.currentSecond();
        CShopcontrol cShopcontrol = shopcontrolSysCache.getOrThrow(shop.getType());

        //刷新次数
        if (cShopcontrol.getMax_refresh_count() > shop.getCurrFreeNum() && cShopcontrol.getZero_free_refresh() != 1) {
            int addCount = (now - shop.getLastFreeTime()) / cShopcontrol.getFree_refresh_time();
            if (addCount > 0) {
                shop.setCurrFreeNum(Math.min(shop.getCurrFreeNum() + addCount, cShopcontrol.getMax_refresh_count()));
                shop.setLastFreeTime(shop.getLastFreeTime() + cShopcontrol.getFree_refresh_time() * addCount);
                updateShop(shop);
            }
        }

        if (cShopcontrol.getZero_free_refresh() == 1 && shop.getLastFreeTime() < DateTimeUtil.dayBreak()) {
            shop.setCurrFreeNum(cShopcontrol.getMax_refresh_count());
            shop.setLastFreeTime(DateTimeUtil.dayBreak());
            updateShop(shop);
        }

        if (shop.getType() == ShopType.DIFFERENT_WORLD.getValue()) {
            List<Integer> allGoodsId = shopDifferentWorldSysCache.getAll().stream().mapToInt(CShopDifferentWorld::getIdx)
                    .collect(ArrayList::new, ArrayList::add, ArrayList::addAll);
            allGoodsId.forEach(goodId -> shop.getItems().putIfAbsent(goodId, 0));
            updateShop(shop);
        }

        // 为空的时候直接刷新一次
        if (!shop.getItems().isEmpty()) {
            // 市场MARKET 需要刷新购买刷新次数
            if (ShopType.MARKET.getValue() == shop.getType() && shop.getRefreshNumTime() < now) {
                shop.setRefreshNum(0);
                shop.setRefreshNumTime(DateTimeUtil.tomorrowBreak());
                updateShop(shop);
            } else if (ShopType.TALENT.getValue() == shop.getType() && shop.getRefreshNumTime() < now) {
                shop.setRefreshNum(0);
                shop.setRefreshNumTime(DateTimeUtil.tomorrowBreak());
                updateShop(shop);
            } else if (ShopType.TEAM_ARENA.getValue() == shop.getType() && shop.getRefreshNumTime() < now) {
                shop.setRefreshNum(0);
                shop.setRefreshNumTime(DateTimeUtil.tomorrowBreak());
                updateShop(shop);
            }
            if (now < shop.getNextRefreshTime() || cShopcontrol.getAuto_refresh_mode() == 0
                    //徐聪改的
                    || cShopcontrol.getAuto_refresh_mode() == 4) {
                return;
            }
        }

        shop.setCurrFreeNum(Math.min(shop.getCurrFreeNum() + cShopcontrol.getDaily_free_refresh(), cShopcontrol.getMax_refresh_count()));
        // 设置下次刷新时间
        shop.setNextRefreshTime(getNextRefreshTime(cShopcontrol.getAuto_refresh_mode()));

        if (shop.getType() == ShopType.TEAM_ARENA.getValue()) {//只刷新周限购商品
            refreshWeekShopItem(shop);
        } else {
            refreshShopItem(shop);
        }

        this.updateShop(shop);
    }

    /**
     * 刷新周限购商品
     *
     * @param shop
     */
    private void refreshWeekShopItem(Shop shop) {
        List<IShop> shopList = getShopValues(shop).stream().filter(iShop -> iShop.getLimit_type() == 1).collect(Collectors.toList());
        if (shopList.isEmpty()) {
            return;
        }
        Map<Integer, Integer> weekItemMap = new HashMap<>();
        shopList.forEach(shopItem -> {
            weekItemMap.put(shopItem.getDropId(), 0);
        });
        shop.getItems().putAll(weekItemMap);
    }

    /**
     * 手动刷新商店物品信息
     *
     * @param shop
     */
    public void refreshShopItem(Shop shop) {
        List<IShop> shopList = getShopValues(shop);
        if (shopList.isEmpty()) {
            return;
        }

        List<IShop> itemList = shopList.stream().filter(iShop -> iShop.getLimit_type() == 0).collect(Collectors.toList());
        CShopcontrol cShopcontrol = shopcontrolSysCache.getOrThrow(shop.getType());
        if (itemList.size() > 0 && cShopcontrol.getGoods_limit() > 0) {
            //大于0的商店配置，按照配置来显示数量
            itemList = DropUtil.randomDifDrop(itemList, cShopcontrol.getGoods_limit());
        }

        //验证周限购商品不会刷新
        List<IShop> weekItemList = shopList.stream().filter(iShop -> iShop.getLimit_type() == 1).collect(Collectors.toList());
        Map<Integer, Integer> weekItemMap = new HashMap<>();
        if (weekItemList.size() > 0) {

            weekItemList.forEach(iShop -> {
                weekItemMap.put(iShop.getDropId(), shop.getItems().get(iShop.getDropId()));
            });

        }

        shop.clearItems();
        for (IDrop shopItem : itemList) {
            shop.getItems().put(shopItem.getDropId(), 0);
        }

        shop.getItems().putAll(weekItemMap);
        this.updateShop(shop);
    }

    private List<IShop> getShopValues(Shop shop) {
        int shopType = shop.getType();

        List<IShop> dropList = new ArrayList<>();
        if (shopType == ShopType.MARKET.getValue()) {
            // 市场
            Role role = roleService.getOrThrow(shop.getRid());
            for (CShopmarket cShopmarket : shopmarketSysCache.getAll()) {
                if (role.getLevel() >= cShopmarket.getLevel_require_min()
                        && role.getLevel() <= cShopmarket.getLevel_require_max()) {
                    dropList.add(cShopmarket);
                }
            }
        } else if (shopType == ShopType.WISH_POOL.getValue()) {
            // 池商店
            dropList.addAll(shopwishpoolSysCache.getAll());
        } else if (shopType == ShopType.PROPHECY.getValue()) {
            // 先知商店
            dropList.addAll(shopprophecySysCache.getAll());
        } else if (shopType == ShopType.SACRIFICE.getValue()) {
            // 祭坛商店
            dropList.addAll(shopsacrificeSysCache.getAll());
        } else if (shopType == ShopType.PVP_NORMAL.getValue()) {
            // 竞技场商店
            dropList.addAll(shoppvpnormalSysCache.getAll());
        } else if (shopType == ShopType.CLAN.getValue()) {
            // 公会商店
            dropList.addAll(shopclanSysCache.getAll());
        } else if (shopType == ShopType.ADVENTURE.getValue()) {
            // 试炼商店
            dropList.addAll(shopadventureSysCache.getAll());
        } else if (shopType == ShopType.STALL.getValue()) {
            // 黑市商店
            dropList.addAll(shopstallSysCache.getAll());
        } else if (shopType == ShopType.PROMOTION.getValue()) {
            // 秘境商店
            dropList.addAll(shoppromotionSysCache.getAll());
        } else if (shopType == ShopType.HERO.getValue()) {
            //英雄商店
            dropList.addAll(shopHeroSysCache.getAll());
        } else if (shopType == ShopType.RUNES.getValue()) {
            //精灵商店
            dropList.addAll(shopRunesSysCache.getAll());
        } else if (shopType == ShopType.LADDER.getValue()) {
            //跨服天梯积分商店
            dropList.addAll(shopLadderSysCache.getAll());
        } else if (shopType == ShopType.FRAGMENT.getValue()) {
            //先知碎片商店
            dropList.addAll(shopFragmentSysCache.getAll());
        } else if (shopType == ShopType.TALENT.getValue()) {
            //天赋商店
            dropList.addAll(shopTalentSysCache.getAll());
        } else if (shopType == ShopType.FASHION.getValue()) {
            //皮肤商店
            dropList.addAll(shopFashionSysCache.getAll());
        } else if (shopType == ShopType.GODEQUIPMENT.getValue()) {
            //神装商店
            dropList.addAll(shopGodequipmentSysCache.getAll());
        } else if (shopType == ShopType.CHAMPION.getValue()) {
            //跨服冠军赛商店
            dropList.addAll(shopChampionSysCache.getAll());
        } else if (shopType == ShopType.TEAM_ARENA.getValue()) {
            //组队竞技商店
            dropList.addAll(shopTeamArenaSysCache.getAll());
        } else if (shopType == ShopType.SUPER_HERO.getValue()) {
            //超级英雄商店
            dropList.addAll(shopSuperHeroSysCache.getAll());
        } else if (shopType == ShopType.DAY.getValue()) {
            //直购商店
            dropList.addAll(shopDaySysCache.getAll());
        } else if (shopType == ShopType.STAGE_MATCH.getValue()) {
            //直购商店
            dropList.addAll(shopSuperRankSysCache.getAll());
        } else if (shopType == ShopType.FLOATING_ISLANDS.getValue()) {
            //直购商店
            dropList.addAll(shopFloatingIslandsSysCache.getAll());
        } else if (shopType == ShopType.TIME_TOWER.getValue()) {
            //时空魔塔
            dropList.addAll(shopTimeTowerSysCache.getAll());
        } else if (shopType == ShopType.ZSJT.getValue()) {
            //诸神祭坛商店
            dropList.addAll(shopZsjtSysCashe.getAll());
        } else if (shopType == ShopType.DIFFERENT_WORLD.getValue()) {
            //异界冒险商店
            dropList.addAll(shopDifferentWorldSysCache.getAll());
        } else if (shopType == ShopType.CHRISTMAS.getValue()) {
            //圣诞礼盒商城
            dropList.addAll(shopChristmasSysCache.getAll());
        } else if (shopType == ShopType.MAKE_EGG.getValue()) {
            //制作彩蛋商城
            dropList.addAll(shopMakeEggSysCache.getAll());
        } else if (shopType == ShopType.COUNTRY_WAR.getValue()) {
            //军工商城
            dropList.addAll(shopCountryWarSysCache.getAll());
        } else if (shopType == ShopType.MAGIC_TOWER_DAILY.getValue()) {
            dropList.addAll(magicTowerDailyShopSysCache.getAll());
        } else if (shopType == ShopType.MAGIC_TOWER_LIFT.getValue()) {
            dropList.addAll(magicTowerLifeShopSysCache.getAll());
        }
        return dropList;
    }
}
