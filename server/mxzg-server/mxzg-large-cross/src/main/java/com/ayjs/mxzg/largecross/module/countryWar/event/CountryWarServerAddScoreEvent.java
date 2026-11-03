package com.ayjs.mxzg.largecross.module.countryWar.event;

import lombok.Value;

/**
 * 服务器积分增加事件
 *
 * @Author: CWJ
 * @Date: 2021/4/13
 **/
@Value(staticConstructor = "of")
public class CountryWarServerAddScoreEvent {
    private int serverId;
    private int groupId;
}
