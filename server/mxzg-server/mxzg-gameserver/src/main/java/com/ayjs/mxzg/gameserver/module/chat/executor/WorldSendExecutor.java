package com.ayjs.mxzg.gameserver.module.chat.executor;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.chat.constant.ChatType;
import com.ayjs.mxzg.gameserver.module.chat.event.ChatDeleteEvent;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.friend.service.BlackListService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.ChatGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.language.LanguageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.stream.Collectors;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/13 15:01
 */
@Component
public class WorldSendExecutor implements ISendExecutor {

    private static int CHAT_RECORD_SIZE = 100;

    private CopyOnWriteArrayList<ChatGMsg.GResChat> chatRecord = new CopyOnWriteArrayList<>();

    @Autowired
    RoleService roleService;
    @Autowired
    ContextManager contextManager;
    @Autowired
    private ClanService clanService;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private LanguageHelper languageHelper;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private BlackListService blackListService;
    @Autowired
    private ServerConfig serverConfig;

    @Override
    public ChatType thisType() {
        return ChatType.WORLD;
    }

    @Override
    public ErrorCode send(long sendId, long receiveId, String content, boolean canSendOther, int idx, List<String> params) {
        Role role = null;
        if (sendId != 0)
            role = roleService.getOrThrow(sendId);

        ChatGMsg.GResChat.Builder builder = ChatGMsg.GResChat.newBuilder();
        builder.setChatType(thisType().getValue());
        builder.setSendTime(TimeDateUtil.getCurrentTimeInt());
        builder.setChatContent(content);
        if (role == null) {
            builder.setServerId(serverConfig.getServerId());
        } else {
            builder.setServerId(role.getServerId());
        }
        builder.setPlayerId(sendId);
        if (role != null) {
            builder.setClanName(clanService.getClanName(role));
            builder.setPlayerName(role.getNick());
            builder.setHeadId(role.getHeadId());
            builder.setBorderId(role.getBorderId());
            builder.setPeerage(role.getPeerageChatStatus() == 0 ? 0 : roleService.getRolePeerage(role.getId()));
        } else {
            //策划说写死语言表ID
            CLanguage cLanguage = languageSysCache.getByKey("41199");
            builder.setPlayerName(languageHelper.getLanguageBy(cLanguage));
        }

        builder.setIdx(idx);
        if (params != null) {
            builder.addAllParams(params);
        }

        ChatGMsg.GResChat message = builder.build();
        if (canSendOther) {
            if (chatRecord.size() >= CHAT_RECORD_SIZE) {
                ChatGMsg.GResChat resChat = chatRecord.remove(0);
                eventBus.post(ChatDeleteEvent.of(resChat));
            }
            chatRecord.add(message);
            contextManager.write(CmdCode._6001, message,
                    rid -> !blackListService.inMyBlacklist(rid, sendId));
        } else {
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

    @Override
    public void clearLog(long clanId) {
        chatRecord.clear();
    }
}
