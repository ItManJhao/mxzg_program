package com.ayjs.mxzg.gameserver.module.chat.executor;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.chat.constant.ChatType;
import com.ayjs.mxzg.gameserver.module.chat.dao.ChatDao;
import com.ayjs.mxzg.gameserver.module.chat.domain.Chat;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.friend.domain.Relationship;
import com.ayjs.mxzg.gameserver.module.friend.service.RelationshipService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.ChatGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/13 15:40
 */
@Component
public class PrivateSendExecutor implements ISendExecutor {

    @Autowired
    RoleService roleService;
    @Autowired
    ChatDao chatDao;
    @Autowired
    ContextManager contextManager;
    @Autowired
    private ClanService clanService;
    @Autowired
    private RelationshipService relationshipService;

    private static final int RETAIN_DAY = 7;
    private static final int DEFAULT_SIZE = 50;

    @Override
    public ChatType thisType() {
        return ChatType.PRIVATE_CHAT;
    }

    @Override
    public ErrorCode send(long sendId, long receiveId, String content, boolean canSendOther, int idx, List<String> params) {
        Role role = roleService.getOrThrow(sendId);
        roleService.getOrThrow(receiveId);

        Relationship relationship = relationshipService.getRelationship(sendId, receiveId);
        Relationship relationship2 = relationshipService.getRelationship(receiveId, sendId);
        if (relationship == null || relationship2 == null)
            return ErrorCode.FRIEND_SHIP_MISS;
        //更新小红点状态
        int now = TimeDateUtil.getCurrentTimeInt();

        relationship2.setRedStatus(true);
        relationship2.setChatIng(true);
        relationshipService.updateRelationship(relationship2);

        relationship.setReadTime(now);
        relationship.setRedStatus(false);
        relationshipService.updateRelationship(relationship);


        ChatGMsg.GResChat.Builder builder = ChatGMsg.GResChat.newBuilder();
        builder.setChatType(thisType().getValue());
        builder.setSendTime(now);
        builder.setChatContent(content);
        builder.setPlayerId(sendId);
        builder.setClanName(clanService.getClanName(role));
        builder.setPlayerName(role.getNick());
        builder.setHeadId(role.getHeadId());
        builder.setBorderId(role.getBorderId());
        builder.setFriendId(receiveId);
        builder.setIdx(idx);
        builder.setPeerage(role.getPeerageChatStatus() == 0 ? 0 : roleService.getRolePeerage(role.getId()));
        if (params != null) {
            builder.addAllParams(params);
        }
        if (canSendOther) {
            Chat chat = new Chat();
            chat.setSender(sendId);
            chat.setCreateTime(now);
            chat.setChatType(thisType().getValue());
            chat.setContent(content);
            chat.setReceiver(receiveId);
            chatDao.add(chat);
            // 包含敏感信息不发送
            contextManager.write(receiveId, CmdCode._6001, builder.build());
        }
        contextManager.write(sendId, CmdCode._6001, builder.build());
        return ErrorCode.NO_ERROR;
    }

    @Override
    public List<ChatGMsg.GResChat> getChatLog(long rid) {

        Map<Long, List<Chat>> sendLogs = chatDao.getAllBySender(rid).stream().collect(Collectors.groupingBy(Chat::getReceiver));
        Map<Long, List<Chat>> receiverLogs = chatDao.getAllByReceiver(rid).stream().collect(Collectors.groupingBy(Chat::getSender));

        receiverLogs.forEach((k, v) -> {
            List<Chat> logs = sendLogs.computeIfAbsent(k, key -> new ArrayList<>());
            logs.addAll(v);
        });
//        Role role = roleService.getOrThrow(rid);
        List<ChatGMsg.GResChat> result = new ArrayList<>();

        List<Chat> removeList = new ArrayList<>();

        int now = TimeDateUtil.getCurrentTimeInt();
        sendLogs.values().forEach(list -> {
            getValidLog(result, removeList, now, list);
        });
        if (CollectionUtil.isNotEmpty(removeList)) {
            chatDao.remove(removeList);
        }
        return result;
    }

    /***
     * 有效聊天日志
     * @param result
     * @param removeList
     * @param now
     * @param allList
     */
    private void getValidLog(List<ChatGMsg.GResChat> result, List<Chat> removeList, int now, List<Chat> allList) {
        Collections.sort(allList, new Comparator<Chat>() {
            @Override
            public int compare(Chat o1, Chat o2) {
                return o1.getCreateTime() - o2.getCreateTime();
            }
        });
        //移除记录
        List<Chat> subChats = new ArrayList<>();
        subChats.addAll(allList.subList(Math.max(0, allList.size() - DEFAULT_SIZE), allList.size()));
        if (allList.size() > DEFAULT_SIZE * 2) {
            removeList.addAll(allList.subList(0, allList.size() - DEFAULT_SIZE));
        }

        Iterator<Chat> it = subChats.iterator();
        while (it.hasNext()) {
            Chat chat = it.next();
            if (TimeDateUtil.intervalDays(chat.getCreateTime(), now) <= RETAIN_DAY) {
                ChatGMsg.GResChat.Builder builder = ChatGMsg.GResChat.newBuilder();
                builder.setChatType(thisType().getValue());
                builder.setSendTime(chat.getCreateTime());
                builder.setChatContent(chat.getContent());
                builder.setPlayerId(chat.getSender());

                Role role = roleService.getOrThrow(chat.getSender());
                builder.setClanName(clanService.getClanName(role));

                builder.setClanId(role.getClanId());
                builder.setPlayerName(role.getNick());
                builder.setHeadId(role.getHeadId());
                builder.setBorderId(role.getBorderId());
                builder.setFriendId(chat.getReceiver());
                result.add(builder.build());
                builder.setPeerage(role.getPeerageChatStatus() == 0 ? 0 : roleService.getRolePeerage(role.getId()));
            } else {
                removeList.add(chat);
            }
        }
    }

    /***
     * 获取好友的私聊记录
     * @param rid
     * @param friendId
     * @return
     */
    public List<ChatGMsg.GResChat> getChatLogByFriend(long rid, long friendId) {
        List<Chat> list = chatDao.getChatLog(rid, friendId);
        List<ChatGMsg.GResChat> result = new ArrayList<>();
        List<Chat> removeList = new ArrayList<>();
        getValidLog(result, removeList, TimeDateUtil.getCurrentTimeInt(), list);
        if (!removeList.isEmpty())
            chatDao.remove(removeList);
        return result;
    }

}

