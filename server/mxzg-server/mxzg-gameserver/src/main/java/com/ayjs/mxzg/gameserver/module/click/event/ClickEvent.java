package com.ayjs.mxzg.gameserver.module.click.event;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2020/3/11
 **/
@Value(staticConstructor = "of")
public class ClickEvent {

    /***
     * 玩家id
     */
    private long rid;

    /***
     * 点击码
     */
    private int clickCode;
}
