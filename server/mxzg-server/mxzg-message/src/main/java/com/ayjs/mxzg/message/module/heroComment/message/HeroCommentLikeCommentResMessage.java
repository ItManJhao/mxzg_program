package com.ayjs.mxzg.message.module.heroComment.message;

import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

/**
 * 评论喜恶请求
 *
 * @Author: CWJ
 * @Date: 2020/6/11
 **/
@Value(staticConstructor = "of")
public class HeroCommentLikeCommentResMessage implements RemoteMessage {

    /***
     * 英雄类型
     *
     */
    private int heroType;

    private int code;

}
