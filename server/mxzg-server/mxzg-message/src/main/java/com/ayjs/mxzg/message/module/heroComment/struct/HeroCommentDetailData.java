package com.ayjs.mxzg.message.module.heroComment.struct;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * @Author: CWJ
 * @Date: 2020/6/11
 **/
@Getter
@Setter
public class HeroCommentDetailData {

    /**
     * 唯一id
     */
    private String id;

    /**
     * 内容
     */
    private String context;

    /**
     * 发表评论的id
     */
    private long rid;

    /**
     * 喜欢计数
     */
    private long likeCount;

    /**
     * 不喜欢计数
     */
    private long hateCount;

    private LocalDateTime localDateTime;
}
