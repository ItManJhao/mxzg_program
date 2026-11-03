package com.ayjs.mxzg.message.module.floatingIslands.message;

import com.ayjs.mxzg.message.module.floatingIslands.struct.RankDataRecord;
import com.ayjs.rpc.RemoteMessage;
import lombok.Value;

import java.util.List;

/**
 * 请求排行榜结算记录
 *
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Value(staticConstructor = "of")
public class FloatingIslandsRankSettleRecordResMessage implements RemoteMessage {

    private List<RankDataRecord> rankList;

    private int settleTime;

    private List<Long> totalDmgList;
}
