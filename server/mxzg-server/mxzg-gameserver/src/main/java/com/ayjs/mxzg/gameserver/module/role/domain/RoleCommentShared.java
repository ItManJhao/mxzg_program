package com.ayjs.mxzg.gameserver.module.role.domain;

import lombok.Data;

/**
 * 评价和分享数据
 */
@Data
public class RoleCommentShared {
    /**
     * 评论分享类型
     */
    private int type;
    /**
     * 状态0，没发生，1已评价，2已领奖
     */
    private int state;
    /**
     * 完成时间
     */
    private int datetime;
}
