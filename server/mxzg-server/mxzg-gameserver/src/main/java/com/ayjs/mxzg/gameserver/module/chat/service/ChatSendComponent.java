package com.ayjs.mxzg.gameserver.module.chat.service;

import cn.hutool.http.HttpUtil;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.module.chat.constant.ChatDto;
import com.ayjs.mxzg.gameserver.module.chat.constant.ChatType;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.web.support.WebResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.net.URLDecoder;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

/**
 * 批量发送聊天记录的类，会有定时器定时推送list中的所有聊天记录
 * @author Rondo
 * @date 2021-05-09 20:03:05
 */
@Slf4j
@Component
public class ChatSendComponent {

    @Autowired
    private ContextManager contextManager;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ServerConfig serverConfig;

    private static final String SEND_DATA_URL = "/cli/SendChats/acceptChats";
    // 最大缓存数
    private static final int MAX_CACHE = 1000;
    // 过期时间
    private static final long TIME_OUT_MIN = 30;
    // 缓存列表
    private static final List<ChatDto> list = new CopyOnWriteArrayList<>();

    public void addChatInfo(ChatType chatType, long roleId, long toRoleId, String content) {
        ChatDto chatDto = new ChatDto();
        Role role = roleService.getOrThrow(roleId);
        chatDto.setServer_id("S" + role.getServerId());
        chatDto.setQid(Long.toString(role.getUserId()));
        chatDto.setName(role.getNick());
        chatDto.setType(getRealChatType(chatType));
        chatDto.setContent(content);
        chatDto.setTime(LocalDateTime.now());
        if (contextManager.getOnline(roleId) != null) {
            chatDto.setIp(contextManager.getOnline(role.getId()).getRemoteAddress());
        }
        chatDto.setThird_qid(Long.toString(role.getId()));
        // 接收方的信息
        if (toRoleId != 0) {
            Role toRole = roleService.getOrThrow(toRoleId);
            chatDto.setToqid(Long.toString(toRole.getUserId()));
            chatDto.setToname(toRole.getNick());
            chatDto.setThird_toqid(Long.toString(toRole.getId()));
        }

        list.add(chatDto);
        // 超过最大数，避免内存过大
        if (list.size() > MAX_CACHE) pushInfoToPlatform();
    }

    public void pushInfoToPlatform() {
        if (list.isEmpty()) return;
        HashMap<String, Object> map = new HashMap<>();
        map.put("data", GJsonUtils.toJson(list));
        try {
            String result = HttpUtil.post(serverConfig.getManagementUrl() + SEND_DATA_URL, map, 3000);
            log.debug("pushInfoToPlatform size:{}, result : {}", map.size(), result);
            WebResult webResult = GJsonUtils.fromJson(result, WebResult.class);
            if (webResult.getCode() == 1) {
                log.info("聊天记录推送成功");
                list.clear();
            }else {
                log.error("聊天记录推送失败: " + webResult.getMsg());
                tryToClearTimeOutData();
            }
        } catch(Exception e) {
            log.error("批量发送聊天记录失败，错误：" + e.toString());
        }

    }

    // 尝试删除30分钟前的记录
    private void tryToClearTimeOutData() {
        list.removeIf(chatDto -> {
            return LocalDateTime.now().isAfter(chatDto.getTime().plusMinutes(TIME_OUT_MIN));
        });
    }

    private int getRealChatType(ChatType chatType) {
        // 1 私聊；2 喇叭；3 邮件；4 世界；5 国家；6 工会/帮会；7 队伍；8 附近；9 其他
        if (chatType.getValue() == ChatType.PRIVATE_CHAT.getValue()) {
            return 1;
        } else if (chatType.getValue() == ChatType.WORLD.getValue()) {
            return 4;
        } else if (chatType.getValue() == ChatType.CLAN.getValue()) {
            return 6;
        } else {
            return 9;
        }
    }
}
