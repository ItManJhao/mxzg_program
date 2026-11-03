package com.ayjs.mxzg.gameserver.module.chat.service;

import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.cache.chat.ForbidChatSysCache;
import com.ayjs.mxzg.config.excel.entity.chat.CForbidChat;
import com.ayjs.mxzg.gameserver.module.chat.constant.ChatType;
import com.ayjs.mxzg.gameserver.module.chat.domain.ChatMsgRecord;
import com.ayjs.mxzg.gameserver.module.chat.dao.ForbidChatDao;
import com.ayjs.mxzg.gameserver.module.chat.domain.ForbidChat;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.google.common.collect.Maps;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/9/19
 **/
@Service
public class ForbidChatService {

    @Autowired
    private ForbidChatDao forbidChatDao;
    @Autowired
    private ForbidChatSysCache forbidChatSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private SystemSysCache systemSysCache;

    private Pattern compile = Pattern.compile("[^0-9#]");

    private Map<Long, Map<String, List<Integer>>> chatInfoRecord = Maps.newConcurrentMap();

    private Map<Long, List<ChatMsgRecord>> chatMsgRecord = Maps.newConcurrentMap();


    public void tryForbidRole(long rid, String msg, ChatType chatType) {

        if (chatType != ChatType.WORLD && chatType != ChatType.PROVINCE_CHAT && chatType != ChatType.CROSS_CHAT) {
            return;
        }
        //过滤掉纯表情
        if (!isAllEnjoy(msg)) {
            return;
        }

        int now = TimeDateUtil.getCurrentTimeInt();
        Map<String, List<Integer>> msgMap = chatInfoRecord.computeIfAbsent(rid, key -> new LinkedHashMap<>());
        List<ChatMsgRecord> chatMsgRecords = chatMsgRecord.computeIfAbsent(rid, key -> new ArrayList<>());
        chatMsgRecords.add(ChatMsgRecord.of(msg, now));
        List<Integer> timeList = msgMap.computeIfAbsent(msg, key -> new ArrayList<>());
        timeList.add(now);

        List<ChatMsgRecord> expireList = chatMsgRecords.stream().filter(record -> now - record.getTime() >
                TimeDateUtil.ONEMININT * systemSysCache.getChatRepeatedExpireTime()).collect(Collectors.toList());
        if (expireList.isEmpty() && chatMsgRecords.size() > 100) {
            expireList.add(chatMsgRecords.get(0));
        }
        expireList.forEach(remove -> {
            List<Integer> expireTimeList = msgMap.get(remove.getMsg());
            expireTimeList.remove(Integer.valueOf(remove.getTime()));
        });


        if (timeList.size() < systemSysCache.getChatRepeatedTimes()) {
            return;
        }

        chatInfoRecord.remove(rid);
        chatMsgRecord.remove(rid);
        ForbidChat forbidChat = forbidChatDao.get(rid);
        if (forbidChat == null) {
            forbidChat = new ForbidChat();
            forbidChat.setRid(rid);
            forbidChat.getAfter();
            forbidChatDao.add(forbidChat);
        }

        forbidChat.setCount(forbidChat.getCount() + 1);
        forbidChatDao.update(forbidChat);
        CForbidChat config = forbidChatSysCache.getById(forbidChat.getCount());
        Role role = roleService.getOrThrow(rid);
        role.setForbidWordsEndTime(now + TimeDateUtil.ONEHOURINT * config.getForbid_time());
        roleService.updateRole(role);
    }

    /***
     * 是否是纯表情
     * @param s
     * @return
     */
    private boolean isAllEnjoy(String s) {
        return compile.matcher(s).find();
    }
}
