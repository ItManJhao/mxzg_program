package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.constant;

public enum FleetBuffEnum {
    /**
     * 航队速度
     */
    JIAN_DUI_SU_DU(101),
    /**
     * 航队耐久
     */
    JIAN_DUI_NAI_JIU(102),
    /**
     * 航队进度
     */
    JIAN_DUI_JIN_DU(103)


    ;
    private int type;

    FleetBuffEnum(int type) {
        this.type = type;
    }

    public int getType() {
        return type;
    }

}
