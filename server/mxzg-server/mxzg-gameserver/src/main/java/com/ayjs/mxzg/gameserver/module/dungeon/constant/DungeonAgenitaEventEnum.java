package com.ayjs.mxzg.gameserver.module.dungeon.constant;


/**
 * 庇护所药剂事件枚举类型
 */
public enum DungeonAgenitaEventEnum {

    HP_AGENTIA(901602), //HP回复药剂
    NPC_AGENTIA(901603),   //NPC驱散药剂
    ;


    private int type;

    DungeonAgenitaEventEnum(int type){
        this.type = type;
    };

    public int getType() {
        return type;
    }
}
