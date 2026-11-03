package com.ayjs.mxzg.message.module.ladder.message;


import com.ayjs.rpc.RemoteMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * 返回角色排名
 */
@Getter
@Setter
public class LadderRankResMessage implements RemoteMessage {
    /**
     * 角色id
     */
    private long rid;
    /**
     * 排名
     */
    private int rank;
}
