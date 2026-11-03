package com.ayjs.mxzg.message.module.heroComment.message;

import com.ayjs.mxzg.message.center.CenterServerMessage;
import lombok.Value;

/**
 * 评论喜恶请求
 *
 * @Author: CWJ
 * @Date: 2020/6/11
 **/
@Value(staticConstructor = "of")
public class HeroCommentLikeCommentReqMessage implements CenterServerMessage {

    /***
     * 英雄类型
     *
     */
    private int heroType;

    /***
     * 评论id
     */
    private String commentId;

    /***
     * 1，喜欢，2讨厌
     */
    private int likeState;

}
