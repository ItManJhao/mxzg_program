package com.ayjs.mxzg.gameserver.web.api;

import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.config.excel.cache.AreaSysCache;
import com.ayjs.mxzg.config.excel.entity.CArea;
import com.ayjs.mxzg.gameserver.module.chat.constant.ChatType;
import com.ayjs.mxzg.gameserver.module.chat.executor.ClanSendExecutor;
import com.ayjs.mxzg.gameserver.module.chat.executor.ProvinceSendExecutor;
import com.ayjs.mxzg.gameserver.module.chat.service.ChatService;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.web.constant.WebErrorCode;
import com.ayjs.mxzg.gameserver.web.exception.WebErrorCodeException;
import com.ayjs.mxzg.gameserver.web.support.ChatData;
import com.ayjs.mxzg.gameserver.web.support.WebResult;
import com.ayjs.mxzg.protocol.ChatGMsg;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/2/16
 **/
@Slf4j
@RequestMapping("/chat")
@RestController
public class ChatApi {

    @Autowired
    private ChatService chatService;
    @Autowired
    private ClanSendExecutor clanSendExecutor;
    @Autowired
    private ProvinceSendExecutor provinceSendExecutor;
    @Autowired
    private AreaSysCache areaSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ClanService clanService;

    /***
     *
     * @param chatType
     * 所有频道（0）， 世界聊天(2)军团聊天(3) 跨服(6)同省(7)
     * @param lastTime
     * @return
     */
    @RequestMapping(value = "/getChatLog", method = RequestMethod.GET)
    public String getChatLog(@RequestParam("chatType") int chatType, @RequestParam("lastTime") int lastTime) {
        log.debug("请求聊天频道信息：" + chatType);

        return sendLog(chatType, lastTime);
    }

    private String sendLog(int type, int lastTime) {
        List<ChatData> chatDatas = new ArrayList<>();
        try {

            List<ChatGMsg.GResChat> logAll = new ArrayList<>();
            if (type == 0) {
                logAll.addAll(chatService.getExecutor(ChatType.WORLD).getChatLog(0));
                logAll.addAll(clanSendExecutor.getAllClanRecordList());
                logAll.addAll(chatService.getExecutor(ChatType.CROSS_CHAT).getChatLog(0));
                logAll.addAll(provinceSendExecutor.getChatLogByProvince());
            } else if (type == ChatType.CLAN.getValue()) {
                logAll.addAll(clanSendExecutor.getAllClanRecordList());
            } else if (type == ChatType.PROVINCE_CHAT.getValue()) {
                logAll.addAll(provinceSendExecutor.getChatLogByProvince());
            } else {
                logAll.addAll(chatService.getExecutor(ChatType.valueOf(type)).getChatLog(0));
            }

            logAll.stream().filter(chatLog -> chatLog.getSendTime() > lastTime).forEach(chatLog -> {
                ChatData data = new ChatData();
                data.setChatType(chatLog.getChatType());
                data.setContext(chatLog.getChatContent());
                data.setName(chatLog.getPlayerName());
                data.setRid(chatLog.getPlayerId());
                data.setServerId(chatLog.getServerId());
                data.setTime(chatLog.getSendTime());
                if (roleService.isRole(chatLog.getPlayerId())) {
                    Role role = roleService.getOrThrow(chatLog.getPlayerId());
                    data.setClanId(role.getClanId());
                    data.setClanName(clanService.getClanName(role));
                }
                if (type == ChatType.PROVINCE_CHAT.getValue()) {
                    CArea byId = areaSysCache.getById(chatLog.getCityId());
                    data.setProvince(byId.getCity());
                }
                chatDatas.add(data);
            });
        } catch (WebErrorCodeException e) {
            log.debug("请求聊天记录失败！", e);
            return JsonUtil.toJson(WebResult.of(e.getErrorCode(), e.getMessage()));
        }

        String logString = GJsonUtils.toJson(WebResult.of(WebErrorCode.SUCCESS.getCode(), GJsonUtils.toJson(chatDatas)));
        log.debug("请求聊天频道信息：" + logString);

        return logString;
    }


    /***
     *
     * @param chatType
     * 所有频道（0）， 世界聊天(2)军团聊天(3) 跨服(6)同省(7)
     * @return
     */
    @RequestMapping(value = "/deleteChatLog", method = RequestMethod.GET)
    public String delete(@RequestParam("chatType") int chatType, @RequestParam("clanId") long clanId) {
        log.debug("请求聊天频道信息：" + chatType);
        try {
            chatService.clearLog(ChatType.valueOf(chatType), clanId);
            return JsonUtil.toJson(WebResult.of(WebErrorCode.SUCCESS.getCode(),
                    String.format("清除聊天记录{%s}-{%s}", chatType, clanId)));
        } catch (Exception e) {
            return JsonUtil.toJson(WebResult.of(WebErrorCode.FAIL.getCode(),
                   "", String.format("清除聊天失败，聊天类型：{%s}，公会id：{%s}", chatType, clanId)));
        }

    }


}
