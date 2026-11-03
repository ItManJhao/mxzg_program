package com.ayjs.mxzg.gameserver.module.chat.timer;

import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.chat.service.ChatSendComponent;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
@Slf4j
public class ChatSendTimer extends AbstractCronTask {

    @Autowired
    private ChatSendComponent chatSendComponent;
    @Autowired
    private ServerConfig serverConfig;

    @Override
    public Object identity() {
        return "ChatSendTimer";
    }

    @Override
    public String expression() {
        return "0/21 * * * * ?";
    }

    @Override
    public void run() {
        if (serverConfig.isExternalChatSwitch()) {
            chatSendComponent.pushInfoToPlatform();
        }
    }
}
