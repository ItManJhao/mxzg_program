package com.ayjs.mxzg.gameserver.module.role.constant;

/**
 * 评论分享类型
 */
public enum CommentSharedType {
    APP_STORE_COMMENT(100), // app store 评价
    FB_COMMENT(200), // facebook 评价
    FB_SHARED(300), // facebook 分享
    TWITTER_SHARED(400); //Twitter 分享

    private int type;

    CommentSharedType(int type) {
        this.type = type;
    }

    public int getType() {
        return type;
    }
}
