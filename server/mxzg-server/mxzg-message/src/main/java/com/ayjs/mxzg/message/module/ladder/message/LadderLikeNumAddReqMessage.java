package com.ayjs.mxzg.message.module.ladder.message;

import com.ayjs.mxzg.message.cross.CrossMessage;
import lombok.Value;

/**
 * 请求添加点赞数
 *
 * @Author: CWJ
 * @Date: 2020/1/5
 **/
@Value(staticConstructor = "of")
public class LadderLikeNumAddReqMessage implements CrossMessage {
    private int rank;
    private int serverId;
}
