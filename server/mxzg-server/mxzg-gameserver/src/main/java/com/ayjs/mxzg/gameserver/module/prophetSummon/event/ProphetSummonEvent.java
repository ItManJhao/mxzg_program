package com.ayjs.mxzg.gameserver.module.prophetSummon.event;

import com.ayjs.mxzg.config.excel.entity.CProphecyType;

import lombok.Value;

/**
 * 先知召唤抛出事件
 */
@Value(staticConstructor = "of")
public class ProphetSummonEvent {

    private long rid;

    private int num;//召唤次数
    
    private CProphecyType cProphecyType;
}
