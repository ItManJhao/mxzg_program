package com.ayjs.mxzg.config.struct;

import java.util.HashMap;
import java.util.Map;

/**
 * 英雄职业类型
 *
 * @author hyx
 */
public enum HeroJobType {

    WARRIOR(1, "战士"),

    MAGE(2,"法师"),

    PRIEST(3,"牧师"),

    ASSASSIN(4,"刺客"),
    ;

    HeroJobType(int jobType, String jobNick) {
        this.jobType = jobType;
        this.jobNick = jobNick;
    }


    private int jobType;

    private String jobNick;

    public int getJobType() {
        return jobType;
    }

    public void setJobType(int jobType) {
        this.jobType = jobType;
    }

    public String getJobNick() {
        return jobNick;
    }

    public void setJobNick(String jobNick) {
        this.jobNick = jobNick;
    }

    private static Map<Integer, HeroJobType> typeMap = new HashMap<>();

    static {
        for (HeroJobType type : HeroJobType.values()) {
            typeMap.put(type.jobType, type);
        }
    }

    public static HeroJobType valueOf(int id) {
        return typeMap.get(id);
    }
}
