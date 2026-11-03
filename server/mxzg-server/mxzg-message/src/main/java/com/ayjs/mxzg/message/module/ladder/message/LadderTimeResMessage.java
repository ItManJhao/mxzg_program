package com.ayjs.mxzg.message.module.ladder.message;

import com.ayjs.mxzg.message.cross.CrossMessage;
import com.ayjs.mxzg.message.module.ladder.domain.CrossLadderDateTime;
import lombok.Value;

/**
 * 活动开启时间段
 *
 * @Author: CWJ
 * @Date: 2020/1/5
 **/
@Value(staticConstructor = "of")
public class LadderTimeResMessage implements CrossMessage {
    /**
     * 跨服天梯时间信息
     */
    private CrossLadderDateTime crossLadderDateTime;
}
