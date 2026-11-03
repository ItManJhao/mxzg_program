package com.ayjs.mxzg.gameserver.module.chat.event;

import com.ayjs.mxzg.protocol.ChatGMsg;
import lombok.Value;

/**
 * 用于记录聊天日志
 * @Author: CWJ
 * @Date: 2019/11/24
 **/
@Value(staticConstructor = "of")
public class AddChatLogEvent {

    private ChatGMsg.GResChat log;

    private boolean canSenderOther;
}
