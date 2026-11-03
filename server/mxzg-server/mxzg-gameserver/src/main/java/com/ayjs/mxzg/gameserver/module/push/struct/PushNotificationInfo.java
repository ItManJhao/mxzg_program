package com.ayjs.mxzg.gameserver.module.push.struct;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class PushNotificationInfo {
    private long rid;//角色ID
    private int startTime;//挂机开始时间
    private boolean isSend = false;//是否发
    private int delayTime;//延时时间

    public PushNotificationInfo(long rid, int startTime, boolean isSend, int delayTime) {
        this.rid = rid;
        this.startTime = startTime;
        this.isSend = isSend;
        this.delayTime = delayTime;
    }

    @Override
    public String toString() {
        return "PushNotificationInfo{" +
                "rid=" + rid +
                ", startTime=" + startTime +
                ", isSend=" + isSend +
                '}';
    }
}
