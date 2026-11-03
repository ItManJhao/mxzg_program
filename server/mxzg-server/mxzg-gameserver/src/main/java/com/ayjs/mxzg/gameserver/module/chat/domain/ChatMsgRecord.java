package com.ayjs.mxzg.gameserver.module.chat.domain;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2020/9/20
 **/
@Value(staticConstructor = "of")
public class ChatMsgRecord {

    private String msg;

    private int time;
}
