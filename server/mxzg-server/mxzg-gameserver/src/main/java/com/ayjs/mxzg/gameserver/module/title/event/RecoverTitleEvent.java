package com.ayjs.mxzg.gameserver.module.title.event;

import com.ayjs.mxzg.config.struct.TitleType;
import lombok.Getter;
import lombok.Setter;

/**
 * 回收称号
 */
@Setter
@Getter
public class RecoverTitleEvent {

    private TitleType titleType;    // 称号类型

    public static RecoverTitleEvent valueOf(TitleType titleType){
        RecoverTitleEvent event = new RecoverTitleEvent();
        event.setTitleType(titleType);
        return event;
    }
}
