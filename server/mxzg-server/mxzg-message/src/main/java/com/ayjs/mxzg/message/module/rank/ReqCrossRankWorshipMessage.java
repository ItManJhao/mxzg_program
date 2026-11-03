package com.ayjs.mxzg.message.module.rank;

import com.ayjs.mxzg.message.cross.CrossMessage;
import lombok.Value;

/**
 * 排行榜膜拜
 *
 * @Author: CWJ
 * @Date: 2019/12/18
 **/
@Value(staticConstructor = "createOf")
public class ReqCrossRankWorshipMessage implements CrossMessage {

    /***
     * 排行榜类型
     */
    private int type;

    /***
     * 膜拜者
     */
    private long rid;

    /***
     * 服务器id
     */
    private int serverId;

//    /***
//     * 被膜拜者
//     */
//    private long beWorshipId;

}
