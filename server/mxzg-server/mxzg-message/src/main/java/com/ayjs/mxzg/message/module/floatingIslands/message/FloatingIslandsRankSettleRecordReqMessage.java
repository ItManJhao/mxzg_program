package com.ayjs.mxzg.message.module.floatingIslands.message;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.Getter;
import lombok.Value;

/**
 * 请求排行榜结算记录
 *
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Getter
@Value(staticConstructor = "of")
public class FloatingIslandsRankSettleRecordReqMessage implements LargeCrossMessage {

    /***
     * 上次结算时间
     */
    private int settleTime;
    /**
     * 服务器ids，必须是同一个组
     */
    private Integer[] serverIds;

    public boolean matchServerId(int serverId) {
        for (int subServer : serverIds) {
            if (subServer == serverId) {
                return true;
            }
        }
        return false;
    }
}
