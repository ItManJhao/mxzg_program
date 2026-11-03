package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;

/**
 * 赛季信息请求
 */
public class SeasonReqMessage implements LargeCrossMessage {

    public static SeasonReqMessage getInstance(){
        return new SeasonReqMessage();
    }

}
