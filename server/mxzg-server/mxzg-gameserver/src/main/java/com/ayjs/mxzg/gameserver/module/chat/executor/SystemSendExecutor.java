package com.ayjs.mxzg.gameserver.module.chat.executor;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.chat.constant.ChatType;
import com.ayjs.mxzg.gameserver.module.chat.event.AddChatLogEvent;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.ChatGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.Lists;
import org.apache.commons.collections4.ListUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/13 15:00
 */
@Component
@Observer
public class SystemSendExecutor implements ISendExecutor {

    private static final int DEFAULT_SIZE = 50;
    private static final int RETAIN_TIME = 7;
    private CopyOnWriteArrayList<ChatGMsg.GResChat> chatRecord = new CopyOnWriteArrayList<>();

    @Autowired
    RoleService roleService;
    @Autowired
    ContextManager contextManager;
    @Autowired
    private EventBus eventBus;

    @Override
    public ChatType thisType() {
        return ChatType.SYSTEM;
    }

    @Override
    public ErrorCode send(long sendId, long receiveId, String content, boolean canSendOther, int idx, List<String> params) {
        ChatGMsg.GResChat.Builder builder = ChatGMsg.GResChat.newBuilder();
        builder.setChatType(thisType().getValue());
        builder.setChatContent(content);
        builder.setSendTime(TimeDateUtil.getCurrentTimeInt());
        builder.setIdx(idx);
        if (params != null) {
            builder.addAllParams(params);
        }

        ChatGMsg.GResChat message = builder.build();

        eventBus.post(AddChatLogEvent.of(message, canSendOther));

        if (canSendOther) {
            contextManager.writeAll(CmdCode._6001, message);
        } else {
            // 有敏感信息时只发给他本人
            contextManager.write(sendId, CmdCode._6001, message);
        }
        return ErrorCode.NO_ERROR;
    }

    @Subscribe
    public void listener(AddChatLogEvent event) {
        if (!event.isCanSenderOther()) {
            return;
        }
        chatRecord.add(event.getLog());
        if (chatRecord.size() > DEFAULT_SIZE) {
            chatRecord.remove(0);
        }
        int now = TimeDateUtil.getCurrentTimeInt();

        Iterator<ChatGMsg.GResChat> iterator = new ArrayList<>(chatRecord).iterator();
        while (iterator.hasNext()) {
            ChatGMsg.GResChat record = iterator.next();
            if (TimeDateUtil.intervalDays(record.getSendTime(), now) > RETAIN_TIME) {
                chatRecord.remove(record);
            } else {
                break;
            }
        }
    }

    @Override
    public List<ChatGMsg.GResChat> getChatLog(long rid) {
        //副文本太多，去一部分数量
        if (chatRecord.size() == 0) {
            return Collections.emptyList();
        }
        List<ChatGMsg.GResChat> gResChats = Collections.unmodifiableList(chatRecord);
        return gResChats.subList(Math.max(0, gResChats.size() - 10), gResChats.size());
    }
}
