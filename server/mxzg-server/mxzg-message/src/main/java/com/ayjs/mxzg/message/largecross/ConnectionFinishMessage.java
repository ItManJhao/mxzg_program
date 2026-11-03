package com.ayjs.mxzg.message.largecross;

import lombok.Value;

/**
 * 服务器连接完毕
 *
 * @Author: CWJ
 * @Date: 2020/6/19
 **/
@Value(staticConstructor = "of")
public class ConnectionFinishMessage implements LargeCrossMessage {
    /**
     * 组id，分组id为0时表示未被分组
     */
    private int groupId;

    /**
     * 是否连接完毕拥有跨服
     * @return
     */
    public boolean isSuccess(){
        return this.groupId != 0;
    }

}
