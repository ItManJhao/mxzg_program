package com.ayjs.mxzg.common.top;

import lombok.Builder;
import lombok.Value;

/**
 * 入榜结果
 */
@Builder
@Value
public class TopResult {

    public static final TopResult CANNOT_IN_TOP_N_RESULT = TopResult.builder().status(TopNStatus.CANNOT_IN_TOP_N).build();

    /**
     * 排行榜状态
     */
    private TopNStatus status;
    /**
     * 旧排名
     */
    private int oldRank;
    /**
     * 新排名
     */
    private int newRank;

    public enum TopNStatus {
        /**
         * 未入榜
         */
        CANNOT_IN_TOP_N,
        /**
         * 入榜
         */
        IN_TOP_N,
        /**
         * 掉榜
         */
        OUT_TOP_N,
        /**
         * 榜内变化
         */
        CHANGE_IN_TOP_N
    }
}
