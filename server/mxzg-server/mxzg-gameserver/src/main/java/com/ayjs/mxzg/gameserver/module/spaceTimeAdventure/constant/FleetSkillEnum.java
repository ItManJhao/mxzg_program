package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.constant;

/**
 * 航行科技
 *
 * @author hyx
 */
public enum FleetSkillEnum {

    /**
     * 提升耐久
     */
    JIAN_DUI_ZHUANG_JIA(1),
    /**
     * 提升速度
     */
    DONG_LI_LU(2),
    /**
     * 提升收益
     */
    CHUAN_CANG(3),
    /**
     * 提升阵容属性
     */
    WU_QI_XI_TONG(4),
    ;

    private int type;

    public int getType() {
        return type;
    }

    FleetSkillEnum(int type) {
        this.type = type;
    }

    public static FleetSkillEnum valueOf(int type) {
        FleetSkillEnum fleetSkillEnum = null;
        for (FleetSkillEnum skillEnum : values()) {
            if (skillEnum.getType() == type) {
                fleetSkillEnum = skillEnum;
            }
        }
        return fleetSkillEnum;
    }
}
