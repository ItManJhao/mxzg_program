package com.ayjs.mxzg.message.module.heroComment.message;

import com.ayjs.mxzg.message.center.CenterServerMessage;
import lombok.Value;

/**
 * 点赞英雄
 *
 * @Author: CWJ
 * @Date: 2020/6/11
 **/
@Value(staticConstructor = "of")
public class HeroCommentLikeHeroReqMessage implements CenterServerMessage {

    /***
     * 英雄类型
     */
    private int heroType;

}
