/**
 *
 */
package com.ayjs.mxzg.config.struct;

import com.ayjs.mxzg.common.convert.annotation.EnumMode;
import com.ayjs.mxzg.common.convert.annotation.ValueMode;

import java.util.HashMap;
import java.util.Map;

/**
 * @author YY
 * 队伍类型
 */
@EnumMode(ValueMode.VALUE)
public enum LineUpType {

    MAIN(0),//主线战斗
    TOWER(1),//幻境之塔
    DUNGEON(2),//庇护所
    ADVEN(3),//试炼
    PVP_DEF(4),//PVP防守
    CLAN_BOSS(5),//公会副本
    CLAN_WAR(6),//公会战
    CLAN_WORLD_BOSS(7),//公会世界BOSS
    CHAMPION(8),    //冠军赛
    CHAMPION_CROSS(9), //跨服冠军赛
    LANG_UP(10),    //挂机
    //10+代表诸神副本类型
    ZHU_SHEN_PVE_1(11),//诸神之战副本1
    ZHU_SHEN_PVE_2(12),//诸神之战副本2
    ZHU_SHEN_PVE_3(13),//诸神之战副本3
    ZHU_SHEN_PVE_4(14),//诸神之战副本4

    DREAMLAND(15),//永恒梦境
    LADDER_ATTACKER(16),//跨服天梯进攻
    LADDER_DEFENDER(17),//跨服天梯防守
    RAINBOW(18),//彩虹圣殿
    GOD_RELIC(19),//诸神遗迹
    TEAM_ARENA(20),//组队竞技场
    STAGE_MATCH(22), //段位赛
    fukongdao(23), //TODO 浮空岛
    TIME_TOWER(24), //时空魔塔
    PINNACLE(25),     //巅峰赛

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

    /** 讨伐团 */
    CRUSADE_GROUP(34),
    /** 讨伐团boss */
    CRUSADE_GROUP_BOSS(35),
    /**冥域魔都*/
    HADES(36),
    /***
     *国战
     */
    COUNTRY_WAR(37),

    MAGIC_TOWER(38),
    ;

    private static Map<Integer, LineUpType> typeMap = new HashMap<>();

    static {
        for (LineUpType lineUpType : LineUpType.values()) {
            typeMap.put(lineUpType.getValue(), lineUpType);
        }
    }

    private final int value;

    private LineUpType(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }

    public static LineUpType valueOf(int type) {
        LineUpType lineUpType = typeMap.get(type);
        if (lineUpType == null) {
            lineUpType = LineUpType.MAIN;
        }
        return lineUpType;
    }
}
