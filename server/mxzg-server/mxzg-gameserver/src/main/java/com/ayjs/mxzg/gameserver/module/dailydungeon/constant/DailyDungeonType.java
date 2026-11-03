package com.ayjs.mxzg.gameserver.module.dailydungeon.constant;

import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.gameserver.module.backpack.constant.EquipmentType;
import com.ayjs.mxzg.template.constant.ErrorCode;

/**
 * 每日副本类型
 */
public enum DailyDungeonType {

     GOLD_DUNGEON(1), //金币副本
     EXP_DUNGEON(2),  //经验副本
     HERO_DUNGEON(3),  //英雄副本
     FETTER_DUNGEON(4),    //羁绊副本
     RUNE_DUNGEON(5)  //符文副本
    ;

    DailyDungeonType(int type){this.type = type ;}

    private final int type;

    public int getType() {
        return type;
    }

    public static DailyDungeonType of(int type) {
        DailyDungeonType result = null;
        for (DailyDungeonType dailyDungeonType : DailyDungeonType.values()) {
            if (dailyDungeonType.type == type) {
                result = dailyDungeonType;
                break;
            }
        }
        Asserts.notNull(result, ErrorCode.ERROR_PARAM.getValue(), () -> String.format("获取副本类型出错，value={%d}", type));
        return result;
    }

}
