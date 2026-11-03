package com.ayjs.mxzg.message.module.ladder.message;

import com.ayjs.mxzg.message.cross.CrossMessage;
import com.ayjs.mxzg.message.module.ladder.domain.CrossLadderDateTime;
import lombok.Value;

import java.util.Map;

/**
 * 跨服天梯榜推送给游戏服
 *
 * @Author: CWJ
 * @Date: 2019/12/19
 **/
@Value(staticConstructor = "of")
public class CrossLadderRankResMessage implements CrossMessage {
    //排名列表<rank,CrossLadderRank>
    private Map<Integer, CrossLadderRank> rankMap;
    //是否替换所有
    private boolean replaceAll;
    /**
     * 跨服天梯时间信息（replaceAll为true才发送时间信息）
     */
    private CrossLadderDateTime crossLadderDateTime;

    /***
     * 是否结算,0普通情况，1开始，2结算
     */
    private int computer;
}
