package com.ayjs.mxzg.gameserver.module.chat.executor;

import com.ayjs.mxzg.gameserver.module.chat.constant.ChatType;
import com.ayjs.mxzg.protocol.ChatGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2019/11/2
 **/
public interface ISendExecutor {

    ChatType thisType();

    /**
     * @param sendId       发送方
     * @param receiveId    接收方
     * @param content      内容
     * @param canSendOther 是否可以发送给其他人
     * @return
     */
    ErrorCode send(long sendId, long receiveId, String content, boolean canSendOther, int idx, List<String> params);

    List<ChatGMsg.GResChat> getChatLog(long rid);

    default void clearLog(long clanId) {

    }
}
