/**
 *
 */
package com.ayjs.mxzg.gameserver.module.backpack.service.processor;

import java.util.HashMap;
import java.util.Map;

/**
 * @author YY
 *
 */
public enum ThingType {
    /**
     * 金币
     */
    GOLD(1),
    /**
     * 钻石
     */
    GEM(2),
    /**
     * 角色经验
     */
    ROLE_EXP(3),
    /**
     * 公会经验
     */
    CLAN_EXP(4),
    /**
     * 英雄经验
     */
    HERO_EXP(5),
    /**
     * 道具
     */
    ITEM(6),
    /**
     * 英雄
     */
    HERO(7),
    /**
     * 精灵
     */
    RUNE(8),
    /**
     * 星级英雄道具
     */
    ITEM_HERO(9),
    /**
     * 超级砖石（只有购买获得）暂定名字
     */
    SUPER_GEM(10),
    /**
     * 酒馆冒险点数
     */
    TAVERN(11),
    /**
     * 神装
     */
    GOD_EQUIP(12),

    /**
     * 皮肤（时装）
     */
    FASHION(13),

    /**
     * 随机获得神装
     */
    GOD_EQUIP_CHANCE(14),

    /**
     * 神职经验
     */
    CLERGY_EXP(15),

    /**
     * 期限道具
     */
    TIME_LIMIT_ITEM(16),

    /**
     * 灵器
     */
    REIKI_EQUIP(17),

    /**
     * 宠物
     */
    PET(18),

    /**
     * 航行箱子
     */
    FLEET_BOX(19),

    /**
     * 航行经验
     */
    FLEET_EXP(20),
    /**
     * 图腾
     */
    TOTEMS(21),
    /**
     * 神兵
     */
    SHENBIN(22),
    /***
     * 国战攻击令
     */
    COUNTRY_WAR_ATTACK(23),
    /***
     * 国战迁移令
     */
    COUNTRY_WAR_MOVE(24),
    /***
     * 国战任务积分
     */
    COUNTRY_WAR_SCORE(25),
    /**
     * 魔战
     */
    MAGIC_WAND(26),
    ;
    private int type;

    private static Map<Integer, ThingType> typeMap = new HashMap<>();

    static {
        for (ThingType thingType : ThingType.values()) {
            typeMap.put(thingType.getType(), thingType);
        }
    }

    ThingType(int type) {
        this.type = type;
    }

    public int getType() {
        return type;
    }

    public static ThingType of(int type) {
        return typeMap.get(type);
    }
}
