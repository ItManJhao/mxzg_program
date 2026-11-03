package com.ayjs.mxzg.gameserver.module.role.event;

import lombok.Value;

/**
 * 这个事件会跳等级
 *
 * @Author: CWJ
 * @Date: 2019/10/19
 **/
@Value(staticConstructor = "of")
public class RoleLvUpEvent {
    private long rid;
    private int oldLv;
    private int newLv;

//    public static RoleLvUpEvent of(long rid, int oldLv, int newLv) {
//        RoleLvUpEvent event = new RoleLvUpEvent();
//        event.rid = rid;
//        event.newLv = newLv;
//        event.oldLv = oldLv;
//        return event;
//    }
}
