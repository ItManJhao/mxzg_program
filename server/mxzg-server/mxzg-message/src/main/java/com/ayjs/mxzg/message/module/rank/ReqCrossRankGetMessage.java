package com.ayjs.mxzg.message.module.rank;

import com.ayjs.mxzg.message.cross.CrossMessage;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2019/12/20
 **/
@Value(staticConstructor = "createOf")
public class ReqCrossRankGetMessage implements CrossMessage {
    //排行榜类型
    private int type;

    private int serverId;

}
