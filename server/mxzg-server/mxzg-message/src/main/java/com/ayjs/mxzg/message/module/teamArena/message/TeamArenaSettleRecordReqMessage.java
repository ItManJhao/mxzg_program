package com.ayjs.mxzg.message.module.teamArena.message;

import com.ayjs.mxzg.message.cross.CrossMessage;
import lombok.Value;

/**
 * 请求结算记录
 *
 * @Author: CWJ
 * @Date: 2020/4/11
 **/
@Value(staticConstructor = "of")
public class TeamArenaSettleRecordReqMessage implements CrossMessage {

    private int settleTime;
    private Integer[] serverId;

}
