package com.ayjs.mxzg.gameserver.web.event;


import lombok.Value;

/**
 * 运营活动更改事件
 * @author hyx
 */
@Value(staticConstructor = "of")
public class PromotionChangeEvent {

    private int idx;//更改的活动idx

}
