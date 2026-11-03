package com.ayjs.mxzg.gameserver.module.shop.constant;

import com.ayjs.mxzg.common.collect.MoreCollectors;
import com.ayjs.mxzg.common.util.Asserts;

import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public enum ShopType {
    /**
     * 市场
     */
    MARKET(100100),
    /**
     * 许愿池
     */
    WISH_POOL(100200),
    /**
     * 先知
     */
    PROPHECY(100300),
    /**
     * 祭坛
     */
    SACRIFICE(100400),
    /**
     * 竞技场
     */
    PVP_NORMAL(100500),
    /**
     * 公会
     */
    CLAN(100600),
    /**
     * 试炼
     */
    ADVENTURE(100700),
    /**
     * 黑市
     */
    STALL(100800),
    /**
     * 秘境
     */
    PROMOTION(100900),
    /**
     * 英雄商店
     */
    HERO(101000),
    /**
     * 公会世界BOSS，精灵商店
     */
    RUNES(101100),
    /**
     * 跨服天梯
     */
    LADDER(101200),
    /**
     * 先知碎片商店
     */
    FRAGMENT(101300),
    /**
     * 天赋商店
     */
    TALENT(101400),
    /**
     * 皮肤商店
     */
    FASHION(101500),
    /**
     * 神装商店
     */
    GODEQUIPMENT(101600),
    /**
     * 跨服冠军赛商店
     */
    CHAMPION(101700),
    /**
     * 组队竞技场商店
     */
    TEAM_ARENA(101800),

    /**
     * 超级英雄商店
     */
    SUPER_HERO(101900),

    /**
     * 每日直购商店
     */
    DAY(102000),

    /**
     * 超凡段位赛
     */
    STAGE_MATCH(102100),

    /**
     * 浮空岛
     */
    FLOATING_ISLANDS(102200),

    /**
     * 时空魔塔
     */
    TIME_TOWER(102300),

    /**
     * 诸神祭坛
     */
    ZSJT(102400),

    /**
     * 异界商店
     */
    DIFFERENT_WORLD(102500),

    /***
     * 圣诞礼盒商城
     */
    CHRISTMAS(102600),

    /***
     * 制作彩蛋
     */
    MAKE_EGG(102700),

    /***
     * 军工商城
     */
    COUNTRY_WAR(102800),

    /**
     * 幻魔塔每日商城
     */
    MAGIC_TOWER_DAILY(102900),

    /**
     * 幻魔塔终生商城
     */
    MAGIC_TOWER_LIFT(103000),

    ;

    private final int value;

    ShopType(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }

    private static final Map<Integer, ShopType> ENUMS = Stream.of(values()).collect(
            MoreCollectors.toImmutableMapAndThen(Collectors.toMap(ShopType::getValue, Function.identity())));

    public static ShopType of(int value) {
        ShopType shopType = ENUMS.get(value);
        Asserts.notNull(shopType, () -> String.format("Invalid value for ShopType: %s", value));
        return shopType;
    }

}
