package com.ayjs.mxzg.gameserver.module.chat.executor;

import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.CenterServerSysCache;
import com.ayjs.mxzg.config.excel.entity.CCenterServer;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.chat.constant.ChatType;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.friend.service.BlackListService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.message.module.chat.message.CenterChatMessage;
import com.ayjs.mxzg.protocol.ChatGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.stream.Collectors;

/**
 * 同省聊天
 */
@Slf4j
@Component
public class ProvinceSendExecutor implements ISendExecutor, MessageHandler {

    private static int CHAT_RECORD_SIZE = 50;

//    private CopyOnWriteArrayList<ChatGMsg.GResChat> chatRecord = new CopyOnWriteArrayList<>();

    private ConcurrentHashMap<String, CopyOnWriteArrayList<ChatGMsg.GResChat>> chatLog = new ConcurrentHashMap<>();

    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ClanService clanService;
    @Autowired
    ContextManager contextManager;
    @Autowired
    private CenterServerSysCache centerServerSysCache;
    @Autowired
    private BlackListService blackListService;
    @Autowired
    private ServerConfig serverConfig;

    @Override
    public ChatType thisType() {
        return ChatType.PROVINCE_CHAT;
    }

    @Override
    public ErrorCode send(long sendId, long receiveId, String content, boolean canSendOther, int idx, List<String> params) {
        Role role = roleService.getOrThrow(sendId);
        if (canSendOther) {
            if (StringUtils.isBlank(role.getProvince())) {
                log.warn("role province:{}", role.getProvince());
                return ErrorCode.CHAT_SET_PROVINCE;
            }
            CenterChatMessage.CenterChatMessageBuilder messageBuilder = CenterChatMessage.builder();
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
            builder.setPeerage(role.getPeerageChatStatus() == 0 ? 0 : roleService.getRolePeerage(role.getId()));
            if (params != null) {
                builder.addAllParams(params);
            }

            ChatGMsg.GResChat message = builder.build();
            // 有敏感信息时只发给他本人
            contextManager.write(sendId, CmdCode._6001, message);
        }
        return ErrorCode.NO_ERROR;
    }

    @Override
    public List<ChatGMsg.GResChat> getChatLog(long rid) {
        Role role = roleService.getOrThrow(rid);
        if (StringUtils.isBlank(role.getProvince())) {
            return Collections.emptyList();
        }
        return Collections.unmodifiableList(chatLog.getOrDefault(role.getProvince(),
                new CopyOnWriteArrayList<>())).stream().filter(message ->
                !blackListService.inMyBlacklist(rid, message.getPlayerId())).collect(Collectors.toList());
    }

    public List<ChatGMsg.GResChat> getChatLogByProvince() {
        List<ChatGMsg.GResChat> result = new ArrayList<>();
        for (CopyOnWriteArrayList<ChatGMsg.GResChat> value : chatLog.values()) {
            result.addAll(value);
        }

        return result;
    }

    /**
     * 跨服聊天
     */
    @RemoteMethod
    public void centerChatMessage(CenterChatMessage message, Connection connection) {

        CCenterServer sendServerInfo = centerServerSysCache.getById(message.getServerId());
        int sendGroupId = 0;
        if (Objects.nonNull(sendServerInfo)) {
            sendGroupId = sendServerInfo.getGroup_id();
        }
        CCenterServer currServerInfo = centerServerSysCache.getById(serverConfig.getServerId());
        int currGroupId = 0;
        if (Objects.nonNull(currServerInfo)) {
            currGroupId = currServerInfo.getGroup_id();
        }
        if (sendGroupId != currGroupId) {
            log.debug("send server id:{} groupId:{}, curr serverId:{} groupId:{}",
                    message.getServerId(), sendGroupId,
                    serverConfig.getServerId(), currGroupId);
            return;
        }

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

        CopyOnWriteArrayList<ChatGMsg.GResChat> chatRecord = chatLog.computeIfAbsent(message.getProvince(),
                k -> new CopyOnWriteArrayList<>());

        if (chatRecord.size() >= CHAT_RECORD_SIZE) {
            chatRecord.remove(0);
        }
        chatRecord.add(resMessage);

        // 同省频道是否开启，开启就过滤省份标志，不开就全部发
        if (StringUtils.isNotBlank(message.getProvince())) {
            Set<Long> sendRids = new HashSet<>();
            for (Long onlineRid : contextManager.getOnlineRids()) {
                if (Objects.isNull(onlineRid)) {
                    continue;
                }
                if (blackListService.inMyBlacklist(onlineRid, message.getRid())) {
                    continue;
                }
                if (serverConfig.isGameChatProvincialChannel()) {
                    if (message.getProvince().equals(roleService.getOrThrow(onlineRid).getProvince())) {
                        sendRids.add(onlineRid);
                    }
                } else {
                    sendRids.add(onlineRid);
                }
            }
            contextManager.writeSome(sendRids, CmdCode._6001, resMessage);
        } else {
            log.info("message.getProvince() is null message:{}", GJsonUtils.toJson(message));
        }
    }

    @Override
    public void clearLog(long clanId) {
        chatLog.clear();
    }
}
