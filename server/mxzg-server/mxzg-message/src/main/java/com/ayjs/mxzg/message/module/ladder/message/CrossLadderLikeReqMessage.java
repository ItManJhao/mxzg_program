package com.ayjs.mxzg.message.module.ladder.message;

import com.ayjs.mxzg.message.cross.RemoteServerMessage;
import lombok.Value;

/**
 *
 * 点赞
 * @Author: CWJ
 * @Date: 2020/1/4
 **/
@Value(staticConstructor = "of")
public class CrossLadderLikeReqMessage implements RemoteServerMessage {

    /***
     * 点赞者服务器id
     */
    private int likeServerId;

    /***
     * 点赞者名字
     */
    private String likeName;

    /***
     * 被点赞者
     */
    private long beLikeId;

    /**
     * 被点赞的玩家分区id
     */
    private int beLikeServerId;


    @Override
    public int serverId() {
        return beLikeServerId;
    }
}
