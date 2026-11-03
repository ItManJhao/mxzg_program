package com.ayjs.mxzg.gameserver.module.chat.executor;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.chat.constant.ChatType;
import com.ayjs.mxzg.gameserver.module.chat.event.ChatDeleteEvent;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanMember;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.friend.service.BlackListService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.ChatGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.language.LanguageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.stream.Collectors;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/13 15:33
 */
@Component
public class ClanSendExecutor implements ISendExecutor {

    private static int CHAT_RECORD_SIZE = 100;

    private Map<Long, CopyOnWriteArrayList<ChatGMsg.GResChat>> clanRecord = new ConcurrentHashMap<>();
    @Autowired
    RoleService roleService;
    @Autowired
    ContextManager contextManager;
    @Autowired
    ClanService clanService;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private LanguageHelper languageHelper;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private BlackListService blackListService;

    @Override
    public ChatType thisType() {
        return ChatType.CLAN;
    }

    /***
     *
     * @param sendId
     * @param receiveId
     *          商会id
     * @param content
     */
    @Override
    public ErrorCode send(long sendId, long receiveId, String content, boolean canSendOther, int idx, List<String> params) {
        Role role = null;
        if (sendId != 0) {
            role = roleService.getOrThrow(sendId);
            receiveId = role.getClanId();
        }
        if (receiveId <= 0) {
            return ErrorCode.CLAN_NOT_EXIST;
        }

        Clan clan = clanService.getOrThrow(receiveId);
        int now = TimeDateUtil.getCurrentTimeInt();

        ChatGMsg.GResChat.Builder builder = ChatGMsg.GResChat.newBuilder();
        builder.setChatType(thisType().getValue());
        builder.setSendTime(now);
        builder.setChatContent(content);
        builder.setClanName(clan.getClanName());
        builder.setPlayerId(sendId);
        builder.setClanId(receiveId);
        if (role != null) {
            builder.setServerId(role.getServerId());
            builder.setPlayerName(role.getNick());
            builder.setHeadId(role.getHeadId());
            builder.setBorderId(role.getBorderId());
            builder.setPeerage(role.getPeerageChatStatus() == 0 ? 0 : roleService.getRolePeerage(role.getId()));
        } else {
            //策划说写死语言表ID
            CLanguage cLanguage = languageSysCache.getByKey("41200");
            builder.setPlayerName(languageHelper.getLanguageBy(cLanguage));
        }

        builder.setIdx(idx);
        if (params != null) {
            builder.addAllParams(params);
        }
        ChatGMsg.GResChat message = builder.build();

        if (canSendOther) {
            CopyOnWriteArrayList<ChatGMsg.GResChat> recordList = getClanRecordList(receiveId);
            recordList.add(message);
            if (recordList.size() > CHAT_RECORD_SIZE) {
                ChatGMsg.GResChat resChat = recordList.remove(0);
                eventBus.post(ChatDeleteEvent.of(resChat));
            }
            List<ClanMember> clanMembers = clanService.selectClanMember(receiveId);
            clanMembers.forEach(clanMember -> {
                if (!blackListService.inMyBlacklist(clanMember.getRid(), sendId)) {
                    PlayerContext playerContext = contextManager.getOnline(clanMember.getRid());
                    if (playerContext != null) {
                        playerContext.write(CmdCode._6001, message);
                    }
                }

            });
        } else {
            // 有敏感信息时只发给他本人
            contextManager.write(sendId, CmdCode._6001, message);
        }
        return ErrorCode.NO_ERROR;
    }

    @Override
    public List<ChatGMsg.GResChat> getChatLog(long rid) {
        Role role = roleService.getOrThrow(rid);
        if (role.getClanId() == 0) {
            return Collections.emptyList();
        }

        CopyOnWriteArrayList<ChatGMsg.GResChat> result = clanRecord.get(role.getClanId());
        if (result == null) {
            clanRecord.putIfAbsent(role.getClanId(), new CopyOnWriteArrayList<>());
            result = clanRecord.get(role.getClanId());
        }
        result.stream().filter(message -> !blackListService.inMyBlacklist(rid, message.getPlayerId())).collect(Collectors.toList());
        return result;
//        return Collections.unmodifiableList(getClanRecordList(role.getClanId()));
    }

    private CopyOnWriteArrayList<ChatGMsg.GResChat> getClanRecordList(long clanId) {
        CopyOnWriteArrayList<ChatGMsg.GResChat> result = clanRecord.get(clanId);
        if (result == null) {
            clanRecord.putIfAbsent(clanId, new CopyOnWriteArrayList<>());
            result = clanRecord.get(clanId);
        }
        return result;
    }

    public List<ChatGMsg.GResChat> getAllClanRecordList() {
        List<ChatGMsg.GResChat> result = new ArrayList<>();
        for (CopyOnWriteArrayList<ChatGMsg.GResChat> value : clanRecord.values()) {
            result.addAll(value);
        }
        return result;
    }

    @Override
    public void clearLog(long clanId) {
        clanRecord.get(clanId).clear();
    }
}
