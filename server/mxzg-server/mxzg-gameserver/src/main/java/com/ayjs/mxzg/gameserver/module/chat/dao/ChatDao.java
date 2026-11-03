package com.ayjs.mxzg.gameserver.module.chat.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.chat.domain.Chat;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/13 17:41
 */
@Repository
public class ChatDao extends BaseRepository<Chat> {

    /***
     * 获取玩家所有聊天记录
     * @param rid
     * @return
     */
    public List<Chat> getAllBySender(long rid) {
        Map<String, Object> map = new HashMap<>();
        map.put("sender", rid);
        List<Chat> chatRecords = list(map);
        return chatRecords;
    }

    /***
     * 获取玩家所有聊天记录
     * @param rid
     * @return
     */
    public List<Chat> getAllByReceiver(long rid) {
        Map<String, Object> map = new HashMap<>();
        map.put("receiver", rid);
        List<Chat> chatRecords = list(map);
        return chatRecords;
    }

    /***
     * 获取两个玩家所有聊天记录
     * @param sender
     * @param receiverId
     * @return
     */
    public List<Chat> getChatLog(long sender, long receiverId) {
        List<Chat> chatRecords = new ArrayList<>();
        Map<String, Object> options = new HashMap<>();
        options.put("sender", sender);
        chatRecords.addAll(list(options).stream().filter(chat -> chat.getReceiver() == receiverId).collect(Collectors.toList()));
        Map<String, Object> options2 = new HashMap<>();
        options2.put("receiver", sender);
        chatRecords.addAll(list(options2).stream().filter(chat -> chat.getSender() == receiverId).collect(Collectors.toList()));
        return chatRecords;
    }
}
