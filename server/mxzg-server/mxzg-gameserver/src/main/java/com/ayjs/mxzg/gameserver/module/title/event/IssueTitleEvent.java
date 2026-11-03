package com.ayjs.mxzg.gameserver.module.title.event;

import com.ayjs.mxzg.config.struct.TitleType;
import lombok.Getter;
import lombok.Setter;

/**
 * 发放称号
 */
@Getter
@Setter
public class IssueTitleEvent {

    private long rid;   // 发放称号的玩家

    private TitleType titleType;    // 称号类型

    private int titleId;            // 称号id

    public static IssueTitleEvent createOf(long rid, TitleType titleType, int titleId){
        IssueTitleEvent event = new IssueTitleEvent();
        event.setRid(rid);
        event.setTitleType(titleType);
        event.setTitleId(titleId);
        return event;
    }

}
