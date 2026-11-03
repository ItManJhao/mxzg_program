package com.ayjs.mxzg.message.module.heroComment.message;

import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

/**
 * 点赞英雄
 *
 * @Author: CWJ
 * @Date: 2020/6/11
 **/
@Value(staticConstructor = "of")
public class HeroCommentLikeHeroResMessage implements RemoteMessage {

    /***
     * 英雄点赞次数
     */
    private int heroType;

    private int code;

}
