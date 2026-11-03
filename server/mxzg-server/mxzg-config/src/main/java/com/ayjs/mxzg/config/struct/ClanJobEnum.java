package com.ayjs.mxzg.config.struct;

/**
 * 公会职位
 * @author
 */
public enum ClanJobEnum {

    CLAN_PRESIDENT(1,"会长"),
    CLAN_VICE_PRESIDENT(2,"副会长"),
    CLAN_MEMBER(3,"普通成员")
    ;

    private int jobKey;

    private String jobNick;

    ClanJobEnum(int jobKey,String jobNick){
        this.jobKey = jobKey;
        this.jobNick = jobNick;
    }

    public int getJobKey() {
        return jobKey;
    }

    public String getJobNick() {
        return jobNick;
    }
}
