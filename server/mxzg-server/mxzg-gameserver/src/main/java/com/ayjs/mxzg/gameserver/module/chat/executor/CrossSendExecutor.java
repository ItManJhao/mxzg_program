package com.ayjs.mxzg.gameserver.module.chat.executor;


import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.chat.constant.ChatType;
import com.ayjs.mxzg.gameserver.module.chat.event.ChatDeleteEvent;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.friend.service.BlackListService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.message.module.chat.message.CrossChatMessage;
import com.ayjs.mxzg.protocol.ChatGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.stream.Collectors;

/**
 * 跨服聊天
 */
@Component
public class CrossSendExecutor implements ISendExecutor, MessageHandler {

    private static int CHAT_RECORD_SIZE = 100;

    private CopyOnWriteArrayList<ChatGMsg.GResChat> chatRecord = new CopyOnWriteArrayList<>();

    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ClanService clanService;
    @Autowired
    ContextManager contextManager;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private BlackListService blackListService;

    @Override
    public ChatType thisType() {
        return ChatType.CROSS_CHAT;
    }

    @Override
    public ErrorCode send(long sendId, long receiveId, String content, boolean canSendOther, int idx, List<String> params) {
        Role role = roleService.getOrThrow(sendId);
        if (canSendOther) {
            CrossChatMessage.CrossChatMessageBuilder messageBuilder = CrossChatMessage.builder();
            messageBuilder.chatType(thisType().getValue());
            messageBuilder.rid(sendId);
            messageBuilder.clanId(role.getClanId());
            messageBuilder.sendTime(TimeDateUtil.getCurrentTimeInt());
            messageBuilder.level(role.getLevel());
            messageBuilder.isVip(role.getGoddessVip());
            messageBuilder.headId(role.getHeadId());
            messageBuilder.nick(role.getNick());
            messageBuilder.clanName(clanService.getClanName(role));
            messageBuilder.chatContent(content);
            messageBuilder.borderId(role.getBorderId());
            messageBuilder.idx(idx);
            messageBuilder.province(role.getProvince());
            messageBuilder.peerageLevel(role.getPeerageChatStatus() == 0 ? 0 : roleService.getRolePeerage(role.getId()));
            if (params != null) {
                messageBuilder.params(params);
            }
            messageBuilder.cityId(role.getAreaId());
            messageBuilder.serverId(role.getServerId());
            messageDispatcher.dispatch(messageBuilder.build());
        } else {
            ChatGMsg.GResChat.Builder builder = ChatGMsg.GResChat.newBuilder();
            builder.setChatType(thisType().getValue());
            builder.setSendTime(TimeDateUtil.getCurrentTimeInt());
            builder.setChatContent(content);
            builder.setChatContent(content);
            builder.setPlayerId(sendId);
            builder.setClanName(clanService.getClanName(role));
            builder.setPlayerName(role.getNick());
            builder.setHeadId(role.getHeadId());
            builder.setBorderId(role.getBorderId());
            builder.setIdx(idx);
            builder.setServerId(role.getServerId());
            builder.setCityId(role.getAreaId());
            if (params != null) {
                builder.addAllParams(params);
            }
            builder.setPeerage(role.getPeerageChatStatus() == 0 ? 0 : roleService.getRolePeerage(role.getId()));
            ChatGMsg.GResChat message = builder.build();
            // 有敏感信息时只发给他本人
            contextManager.write(sendId, CmdCode._6001, message);
        }
        return ErrorCode.NO_ERROR;
    }

    @Override
    public List<ChatGMsg.GResChat> getChatLog(long rid) {
        return Collections.unmodifiableList(chatRecord).stream().filter(message ->
                !blackListService.inMyBlacklist(rid, message.getPlayerId())).collect(Collectors.toList());
    }

    /**
     * 跨服聊天
     */
    @RemoteMethod
    public void crossChatMessage(CrossChatMessage message, Connection connection) {
        ChatGMsg.GResChat.Builder builder = ChatGMsg.GResChat.newBuilder();
        builder.setChatType(thisType().getValue());
        builder.setSendTime(TimeDateUtil.getCurrentTimeInt());
        builder.setChatContent(message.getChatContent());
        builder.setPlayerId(message.getRid());
        builder.setClanName(message.getClanName());
        builder.setPlayerName(message.getNick());
        builder.setHeadId(message.getHeadId());
        builder.setBorderId(message.getBorderId());
        builder.setIdx(message.getIdx());
        if (message.getParams() != null) {
            builder.addAllParams(message.getParams());
        }
        builder.setCityId(message.getCityId());
        builder.setServerId(message.getServerId());
        builder.setPeerage(message.getPeerageLevel());
        ChatGMsg.GResChat resMessage = builder.build();

        if (chatRecord.size() >= CHAT_RECORD_SIZE) {
            ChatGMsg.GResChat resChat = chatRecord.remove(0);
            eventBus.post(ChatDeleteEvent.of(resChat));
        }
        chatRecord.add(resMessage);

        contextManager.write(CmdCode._6001, resMessage,
                rid -> !blackListService.inMyBlacklist(rid, message.getRid()));
    }

    @Override
    public void clearLog(long clanId) {
        chatRecord.clear();
    }
}
