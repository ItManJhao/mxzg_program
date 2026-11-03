package com.ayjs.mxzg.message.module.heroComment.message;

import com.ayjs.mxzg.message.center.CenterServerMessage;
import lombok.Value;

/**
 * 评论
 *
 * @Author: CWJ
 * @Date: 2020/6/11
 **/
@Value(staticConstructor = "of")
public class HeroCommentCommentReqMessage implements CenterServerMessage {

    /***
     * 英雄类型
     */
    private int heroType;

    private String comment;

    private long rid;

}
