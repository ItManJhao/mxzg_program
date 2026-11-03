package com.ayjs.mxzg.gameserver.module.role.constant;

/**
 * 评论分享状态
 */
public enum CommentSharedState {
    UNDONE(0), // 还没发生
    COMPLETED(1), // 已完成
    RECEIVED(2); // 已领取

    private int state;

    CommentSharedState(int state) {
        this.state = state;
    }

    public int getState() {
        return this.state;
    }
}
