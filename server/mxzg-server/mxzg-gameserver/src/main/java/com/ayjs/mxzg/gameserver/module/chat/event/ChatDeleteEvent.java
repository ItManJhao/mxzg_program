package com.ayjs.mxzg.gameserver.module.chat.event;

import com.ayjs.mxzg.protocol.ChatGMsg;
import lombok.Value;

/**
 * 聊天记录清除事件
 * @author hyx
 */
@Value(staticConstructor = "of")
public class ChatDeleteEvent {

    private ChatGMsg.GResChat resChat;
}
