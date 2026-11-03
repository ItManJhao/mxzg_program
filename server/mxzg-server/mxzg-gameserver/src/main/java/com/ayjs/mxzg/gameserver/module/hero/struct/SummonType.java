package com.ayjs.mxzg.gameserver.module.hero.struct;

import java.util.HashMap;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2019/10/26
 **/
public enum SummonType {
    /**
     * 普通
     */
    NORMAL(1, "3401"),
    /**
     * 友情
     */
    FRIEND(2, "3402"),
    /**
     * 高级
     */
    HIGH(3, "3403"),
    /**
     * 新英雄抽卡
     */
    NEW_HERO(5, "3404"),
    ;
    private int type;
    private String langKey;

    SummonType(int type, String langKey) {
        this.type = type;
        this.langKey = langKey;
    }

    public int getType() {
        return type;
    }

    private static Map<Integer, SummonType> typeMap = new HashMap<>();

    static {
        for (SummonType type : SummonType.values()) {
            typeMap.put(type.getType(), type);
        }
    }

    public static SummonType valueOf(int id) {
        return typeMap.get(id);
    }

	public String getLangKey() {
		return langKey;
	}

}
