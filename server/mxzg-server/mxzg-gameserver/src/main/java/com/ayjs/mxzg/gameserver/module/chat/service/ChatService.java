package com.ayjs.mxzg.gameserver.module.chat.service;

import com.ayjs.mxzg.common.base.IRegister;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.module.chat.constant.ChatType;
import com.ayjs.mxzg.gameserver.module.chat.executor.ISendExecutor;
import com.ayjs.mxzg.gameserver.module.friend.domain.BlackList;
import com.ayjs.mxzg.gameserver.module.friend.service.BlackListService;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.ImmutableList;
import com.google.protobuf.GeneratedMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/12 18:09
 */
@Service
@Slf4j
public class ChatService implements IRegister<ISendExecutor> {

    @Autowired
    private BlackListService blackListService;
    @Autowired
    private ContextManager contextManager;

    public Map<ChatType, ISendExecutor> executorMap = new HashMap<>();

    @Override
    public void registerBean(ISendExecutor bean) {
        ISendExecutor old = executorMap.put(bean.thisType(), bean);
        if (Objects.nonNull(old)) {
            throw new RuntimeException(String.format("聊天类型冲突：{%s}-{%s}", bean.getClass().getName(), old.getClass().getName()));
        }
    }

    public ISendExecutor getExecutor(ChatType chatType) {
        return executorMap.get(chatType);
    }

    /**
     * 发送信息
     *
     * @param chatType 频道名
     * @param message  发送的信息
     */
    public ErrorCode send(ChatType chatType, String message, long sender, long receiveId) {
        return send(chatType, message, sender, receiveId, true);
    }

    public ErrorCode send(ChatType chatType, String message, long sender, long receiveId, boolean canSendOther) {
        return getExecutor(chatType).send(sender, receiveId, message, canSendOther, 0, null);
    }

    public ErrorCode send(ChatType chatType, String message, long sender, long receiveId, boolean canSendOther, int idx, List<String> params) {
        return getExecutor(chatType).send(sender, receiveId, message, canSendOther, idx, params);
    }

    /***
     *
     * @param cmd
     * @param msg
     * @param rid
     *          发送玩家
     */
    public void broadcastFilterBlackList(int cmd, GeneratedMessage msg, long rid) {
        Collection<PlayerContext> allOnline = ImmutableList.copyOf(contextManager.getAllOnline());
        allOnline.stream().filter(playerContext -> playerContext.getId() > 0).forEach(context -> {
            BlackList blackList = blackListService.load(context.getId());
            if (blackList.getCrossBlacks().containsKey(context.getId())) {
                context.write(cmd, msg);
            }
        });
    }

    /***
     * 清除记录
     * @param chatType
     */
    public void clearLog(ChatType chatType, long clanId) {
        getExecutor(chatType).clearLog(clanId);
    }
}
