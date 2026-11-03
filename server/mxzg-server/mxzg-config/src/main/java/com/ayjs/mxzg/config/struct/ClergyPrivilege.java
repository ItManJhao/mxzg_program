package com.ayjs.mxzg.config.struct;

/**
 * 神职特权
 * @author hyx
 */
public class ClergyPrivilege {

    private ClergyPrivilegeType type;

    /**
     *  效用值（加成值时为百分比）
     */
    private int value;

    /**
     * 效用触发百分比
     */
    private int chance ;

    public ClergyPrivilegeType getType() {
        return type;
    }

    public void setType(ClergyPrivilegeType type) {
        this.type = type;
    }

    public int getChance() {
        return chance;
    }

    public void setChance(int chance) {
        this.chance = chance;
    }

    public int getValue() {
        return value;
    }

    public void setValue(int value) {
        this.value = value;
    }
}
