package com.ayjs.mxzg.gameserver.module.chat.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.common.util.SymbolConstants;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.OpenConditionSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.COpenCondition;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.chat.constant.ChatType;
import com.ayjs.mxzg.gameserver.module.chat.executor.ISendExecutor;
import com.ayjs.mxzg.gameserver.module.chat.executor.PrivateSendExecutor;
import com.ayjs.mxzg.gameserver.module.chat.service.ChatSendComponent;
import com.ayjs.mxzg.gameserver.module.chat.service.ChatService;
import com.ayjs.mxzg.gameserver.module.chat.service.ForbidChatService;
import com.ayjs.mxzg.gameserver.module.friend.domain.Relationship;
import com.ayjs.mxzg.gameserver.module.friend.service.RelationshipService;
import com.ayjs.mxzg.gameserver.module.role.constant.EntryType;
import com.ayjs.mxzg.gameserver.module.role.constant.RoleParamType;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.domain.RoleParam;
import com.ayjs.mxzg.gameserver.module.role.service.RoleParamService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.sensitive.service.SensitiveWordService;
import com.ayjs.mxzg.protocol.ChatGMsg;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/12 18:02
 */
@Component
public class ChatHandler extends ProtocolHandler {
    @Autowired
    ChatService chatService;
    @Autowired
    private SensitiveWordService sensitiveWordService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private PrivateSendExecutor privateSendExecutor;
    @Autowired
    private RelationshipService relationshipService;
    @Autowired
    private OpenConditionSysCache openConditionSysCache;
    @Autowired
    private RoleParamService roleParamService;
    @Autowired
    private ForbidChatService forbidChatService;
    @Autowired
    private ChatSendComponent chatSendComponent;
    @Autowired
    private ServerConfig serverConfig;


    @CMD(id = CmdCode._6001)
    public void send(PlayerContext playerContext, ChatGMsg.GReqChat req) {
        int type = req.getType();
        ChatType chatType = ChatType.valueOf((short) type);
        Asserts.notNull(chatType, ErrorCode.CHAT_TYPE_NOT_EXIST.getValue(),
                () -> String.format("chat type is null:%s", type));

        Role role = roleService.getOrThrow(playerContext.getId());
        int chatLevel = systemSysCache.getChatUnlockMainLevel();
        Asserts.isTrue(role.getLevel() >= chatLevel, ErrorCode.CHAT_LEVEL_NOT_ENOUGH.getValue(),
                () -> String.format("cant chat role level:%s, need level:%s", role.getLevel(), chatLevel));

        // 是否被禁言
        Asserts.isTrue(role.getForbidWordsEndTime() < DateTimeUtil.currentSecond(),
                ErrorCode.CHAT_FORBID.getValue(), () -> String.format("ForbidWordsEndTime:%s, current:%s",
                        role.getForbidWordsEndTime(), DateTimeUtil.currentSecond()));

        int frequencyAtLeast = systemSysCache.getChatFrequencyAtLeast();
        int now = DateTimeUtil.currentSecond();
        if (chatType != ChatType.PRIVATE_CHAT) {
            Asserts.isTrue(playerContext.getLastReqChatTime() + frequencyAtLeast <= now,
                    ErrorCode.CHAT_SEND_TOO_FREQUENTLY.getValue(),
                    () -> String.format("last req time:%s, current time:%s", playerContext.getLastReqChatTime(),
                            now));
            playerContext.setLastReqChatTime(now);
        }
        if (chatType == ChatType.CROSS_CHAT) {
            COpenCondition condition = openConditionSysCache.getCondition(EntryType.MAIN_CHAT_CROSS_SHARE);
            Asserts.isTrue(role.getLevel() >= condition.getCondition_value(),
                    ErrorCode.CHAT_LEVEL_NOT_ENOUGH.getValue(),
                    () -> String.format("cross chat role level:%s need:%s", role.getLevel(), condition.getCondition_value()));
        }
        if (chatType == ChatType.PROVINCE_CHAT) {
            COpenCondition condition = openConditionSysCache.getCondition(EntryType.MAIN_CHAT_CITY);
            Asserts.isTrue(role.getLevel() >= condition.getCondition_value(),
                    ErrorCode.CHAT_LEVEL_NOT_ENOUGH.getValue(),
                    () -> String.format("province chat role level:%s need:%s", role.getLevel(), condition.getCondition_value()));
        }

        String msg = req.getMsg();

        //去掉换行符
        msg = msg.replaceAll("\r|\n", " ");
        msg = msg.replaceAll(SymbolConstants.AMPERSAND, SymbolConstants.ASTERISK);

        Asserts.isTrue(StringUtil.getShowLength(msg) <= systemSysCache.getChatLimitSize(),
                ErrorCode.CHAT_CONTENT_LENGTH_LONG.getValue(), String.format("聊天内容长度过长：字符长度：{%s}，限制长度{%s}",
                        StringUtil.getShowLength(msg), systemSysCache.getChatLimitSize()));

        boolean canSendOther = sensitiveWordService.wordCanUseChat(msg);
        msg = sensitiveWordService.filterSensitiveWord(msg,role);

        ErrorCode code = chatService.send(chatType, msg, playerContext.getId(), req.getRid(), canSendOther);
        if (code != ErrorCode.NO_ERROR) {
            playerContext.writeError(code);
        }

        if (serverConfig.isExternalChatSwitch()) {
            chatSendComponent.addChatInfo(chatType, playerContext.getId(), req.getRid(), msg);
        }

        forbidChatService.tryForbidRole(playerContext.getId(), req.getMsg(), chatType);
    }


    @CMD(id = CmdCode._6002)
    public void sendLog(PlayerContext playerContext, ChatGMsg.GReqChatLog req) {
        ChatGMsg.GResChatLog.Builder builder = ChatGMsg.GResChatLog.newBuilder();
//        for (ChatType chatType : ChatType.values()) {
//            ISendExecutor handler = chatService.getExecutor(chatType);
//            if (handler != null) {
//                List<ChatGMsg.GResChat> chatLogs = handler.getChatLog(playerContext.getId());
//                if (chatLogs != null && !chatLogs.isEmpty())
//                    builder.addAllChatLog(chatLogs);
//            }
//        }
        playerContext.write(CmdCode._6002, builder.build());
    }

    @CMD(id = CmdCode._6003)
    public void sendPrivateLog(PlayerContext playerContext, ChatGMsg.GReqPrivateChatLog req) {
        Relationship relationship = relationshipService.getRelationship(playerContext.getId(), req.getFriendId());

        Asserts.notNull(relationship, ErrorCode.FRIEND_SHIP_MISS.getValue(), "不是好友关系");

        ChatGMsg.GResPrivateChatLog.Builder builder = ChatGMsg.GResPrivateChatLog.newBuilder();
        List<ChatGMsg.GResChat> chatLogs = privateSendExecutor.getChatLogByFriend(playerContext.getId(), req.getFriendId());
        if (chatLogs != null && !chatLogs.isEmpty()) {
            builder.addAllChatLog(chatLogs);
            builder.setFriendId(req.getFriendId());
            playerContext.write(CmdCode._6003, builder.build());
        }
    }

    @CMD(id = CmdCode._6004)
    public void sendPrivateRoleList(PlayerContext playerContext, ChatGMsg.GReqPrivateChatRoles req) {
        Map<Long, Relationship> shipMap = relationshipService.getShipMap(playerContext.getId());
        ChatGMsg.GResPrivateChatRoles.Builder builder = ChatGMsg.GResPrivateChatRoles.newBuilder();

        shipMap.values().forEach(relationship -> {
            if (relationship.isChatIng() || relationship.isRedStatus()) {
                ChatGMsg.PrivateChatStatus.Builder statusBuilder = ChatGMsg.PrivateChatStatus.newBuilder();
                statusBuilder.setRid(relationship.getRelationRid());
                statusBuilder.setRedStatus(relationship.isRedStatus() ? 1 : 0);
                builder.addList(statusBuilder);
            }
        });
        playerContext.write(CmdCode._6004, builder.build());
    }

    @CMD(id = CmdCode._6005)
    public void openChatIng(PlayerContext playerContext, ChatGMsg.GReqAddPrivateChat req) {
        Relationship relationship = relationshipService.getRelationship(playerContext.getId(), req.getRoleId());

        Asserts.notNull(relationship, ErrorCode.FRIEND_SHIP_MISS.getValue(),
                String.format("非好友关系{%s}-{%s}", playerContext.getId(), req.getRoleId())
        );
        relationship.setChatIng(true);
        relationshipService.updateRelationship(relationship);

        ChatGMsg.GResAddPrivateChat.Builder builder = ChatGMsg.GResAddPrivateChat.newBuilder();
        builder.setRoleId(req.getRoleId());
        playerContext.write(CmdCode._6005, builder.build());

    }

    @CMD(id = CmdCode._6006)
    public void closeChatIng(PlayerContext playerContext, ChatGMsg.GReqRemovePrivateChat req) {
        Relationship relationship = relationshipService.getRelationship(playerContext.getId(), req.getRoleId());

        Asserts.notNull(relationship, ErrorCode.FRIEND_SHIP_MISS.getValue(),
                String.format("非好友关系{%s}-{%s}", playerContext.getId(), req.getRoleId())
        );
        relationship.setChatIng(false);
        relationshipService.updateRelationship(relationship);

        ChatGMsg.GResRemovePrivateChat.Builder builder = ChatGMsg.GResRemovePrivateChat.newBuilder();
        builder.setRoleId(req.getRoleId());
        playerContext.write(CmdCode._6006, builder.build());

    }

    @CMD(id = CmdCode._6007)
    public void chatLogByType(PlayerContext playerContext, ChatGMsg.GReqChatLogByType req) {
        int type = req.getType();
        ChatType chatType = ChatType.valueOf((short) type);
        Asserts.notNull(chatType, ErrorCode.CHAT_TYPE_NOT_EXIST.getValue(),
                () -> String.format("chat type is null:%s", type));

        ISendExecutor handler = chatService.getExecutor(chatType);
        ChatGMsg.GResChatLogByType.Builder builder = ChatGMsg.GResChatLogByType.newBuilder();
        if (handler != null) {
            List<ChatGMsg.GResChat> chatLogs = handler.getChatLog(playerContext.getId());
            if (chatLogs != null && !chatLogs.isEmpty())
                builder.addAllChatLog(chatLogs);
        }
        builder.setType(type);
        playerContext.write(CmdCode._6007, builder.build());
    }

    @CMD(id = CmdCode._6008)
    public void readChat(PlayerContext playerContext, ChatGMsg.GReqChatLogRead req) {
        int typeId = req.getType();
        if (ChatType.PRIVATE_CHAT.getValue() == typeId) {
            Relationship relationship = relationshipService.getRelationship(playerContext.getId(), req.getFriendId());
            Asserts.notNull(relationship, ErrorCode.FRIEND_SHIP_MISS.getValue(), String.format("未找到好友关系{%s}-{%s}", req.getFriendId(), playerContext.getId()));

            relationship.setRedStatus(false);
            relationship.setReadTime(TimeDateUtil.getCurrentTimeInt());
            relationshipService.updateRelationship(relationship);
        } else {

            RoleParam roleParam = roleParamService.getOrCreate(playerContext.getId(), RoleParamType.CHAT_READ_TIME, () -> new HashMap());
            Map<String, String> map = roleParam.parseJson(HashMap.class);

            map.put(typeId + "", TimeDateUtil.getCurrentTimeInt() + "");
            roleParam.saveJson(map);
            roleParamService.update(roleParam);
        }

    }

    @CMD(id = CmdCode._6009)
    public void sendChatNum(PlayerContext playerContext, ChatGMsg.GReqChatNum req) {
        ChatType[] typeList = ChatType.values();
        ChatGMsg.GResChatNum.Builder builder = ChatGMsg.GResChatNum.newBuilder();
        RoleParam roleParam = roleParamService.getOrCreate(playerContext.getId(), RoleParamType.CHAT_READ_TIME, () -> new HashMap());
        Map<String, String> map = roleParam.parseJson(HashMap.class);
        for (ChatType chatType : typeList) {
            int num = 0;
            if (chatType == ChatType.PRIVATE_CHAT) {
                List<ChatGMsg.GResChat> chatLog = privateSendExecutor.getChatLog(playerContext.getId());
                for (ChatGMsg.GResChat gResChat : chatLog) {
                    Relationship relationship = null;
                    if (gResChat.getPlayerId() == playerContext.getId()) {
                        relationship = relationshipService.getRelationship(playerContext.getId(), gResChat.getFriendId());
                    } else {
                        relationship = relationshipService.getRelationship(playerContext.getId(), gResChat.getPlayerId());
                    }
                    if (relationship != null && gResChat.getSendTime() > relationship.getReadTime()) {
                        num++;
                    }
                }
            } else {
                int readTime = Integer.valueOf(map.getOrDefault(chatType.getValue() + "", 0 + ""));
                num = (int) chatService.getExecutor(chatType).getChatLog(playerContext.getId()).stream()
                        .filter(resChat -> resChat.getSendTime() > readTime).count();
            }
            ObjectGMsg.PSMapData.Builder mapBuilder = ObjectGMsg.PSMapData.newBuilder();
            mapBuilder.setKey(chatType.getValue());
            mapBuilder.setValue(num);
            builder.addTypeNum(mapBuilder);

        }
        playerContext.write(CmdCode._6009, builder.build());

    }

}
