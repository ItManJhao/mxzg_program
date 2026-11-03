package com.ayjs.mxzg.gameserver.module.dungeon.constant;

/**
 * 地牢规则数值枚举
 */
public enum DungeonEnum {


    GRID_TYPE1_MAX(5), //网格类型1的最大取值
    GRID_TYPE2_MAZ(3),   //网格类型2的最大值
    NPC_1(1),//左上角NPC怪物icon_level值
    NPC_2(2),//右上角NPC怪物icon_level值
    NPC_3(3),//左下角NPC怪物icon_level值
    NPC_4(4),//右上角NPC怪物icon_level值
    NPC_5(5),//中央NPC怪物icon_level值
    HP_RATE(10000),//地牢满血量比率
    ;

    public int getType() {
        return type;
    }

    private int type;

    DungeonEnum(int type) {
        this.type = type;
    }
}
