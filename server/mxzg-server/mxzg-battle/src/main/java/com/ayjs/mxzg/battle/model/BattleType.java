package com.ayjs.mxzg.battle.model;

import com.ayjs.mxzg.common.convert.annotation.EnumMode;
import com.ayjs.mxzg.common.convert.annotation.ValueMode;
import lombok.Getter;

/**
 * 战斗类型
 *
 * @author meiyc
 */
@EnumMode(ValueMode.VALUE)
@Getter
public enum BattleType {

    /**
     * 主线
     */
    MAIN(1),
    /**
     * 日常副本
     */
    DAILY(2),
    /**
     * 幻境之塔
     */
    TOWER(3),
    /**
     * 竞技场
     */
    ARENA(4),
    /**
     * 公会副本
     */
    CLAN_BOSS(5),
    /**
     * 勇者试炼
     */
    TRIAL(6),
    /**
     * 月神庇护所
     */
    SHELTER(7),
    /**
     * 公会世界BOSS
     */
    CLAN_WORLD_BOSS(8),
    /**
     * 公会战
     */
    CLAN_WAR(9),
    /**
     * 挂机
     */
    HANG_UP(10),
    /**
     * 永恒梦境
     */
    DREAMLAND(11),
    /**
     * 冠军赛
     */
    CHAMPION(12),
    /**
     * 切磋
     */
    STUDY(13),

    /**
     * 跨服天梯进攻
     */
    LADDER_ATTACK(14),

    /**
     * 跨服天梯防守
     */
    LADDER_DEFEND(15),

    /**
     * 彩虹圣殿
     */
    RAINBOW(17),

    /**
     * 诸神遗迹
     */
    GOD_RELIC(19),

    /**
     * 组队竞技场
     */
    TEAM_ARENA(20),

    /**
     * 段位赛
     */
    STAGE_MATCH(22),

    /**
     * 浮空岛
     */
    FLOATING_ISLANDS(23),

    /**
     * 时空魔塔
     */
    TIME_TOWER(24),

    /**
     * 巅峰赛
     */
    PINNACLE(25),

    SPACE_TIME_WEAPON(26), //时空冒险武器系统
    SPACE_TIME_IMPETUS(27), //时空冒险动力系统
    SPACE_TIME_MONSTER(28), //时空冒险挑战队伍

    /***
     * 位面战争
     */
    PLANE_WAR_1(29),
    PLANE_WAR_2(30),
    PLANE_WAR_3(31),
    PLANE_WAR_4(32),
    PLANE_WAR_5(33),

    /**
     * 讨伐团
     */
    CRUSADE_GROUP(34),

    /**
     * 讨伐团
     */
    CRUSADE_GROUP_BOSS(35),

    /***
     * 冥域魔都
     */
    HADED(36),

    /***
     * 国战
     */
    COUNTRY_WAR(37),

    /***
     * 幻魔塔
     */
    MAGIC_TOWER(38),

    //50+代表诸神副本类型
    /**
     * 诸神之战副本1
     */
    ZHU_SHEN_PVE_1(51),//诸神之战副本1
    ZHU_SHEN_PVE_2(52),//诸神之战副本2
    ZHU_SHEN_PVE_3(53),//诸神之战副本3
    ZHU_SHEN_PVE_4(54),//诸神之战副本4

    ;

    private int value;

    private BattleType(int value) {
        this.value = value;
    }

    public static BattleType valueOf(int value) {
        for (BattleType battleType : BattleType.values()) {
            if (battleType.value == value) {
                return battleType;
            }
        }
        throw new RuntimeException("不存在该battleType:" + value);
    }

}
