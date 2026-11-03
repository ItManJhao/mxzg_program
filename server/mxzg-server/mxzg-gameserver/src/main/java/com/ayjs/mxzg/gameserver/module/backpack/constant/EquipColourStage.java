package com.ayjs.mxzg.gameserver.module.backpack.constant;


/**
 * 装备颜色枚举
 * @author hyx
 */
public enum EquipColourStage {

    GREEN(1),

    BLUE(2),

    PURPLE(3),

    ORANGE(4),

    RED(5),

    ;

    EquipColourStage(int type){this.type = type;}

    private int type;

    public int getType() {
        return type;
    }
}
