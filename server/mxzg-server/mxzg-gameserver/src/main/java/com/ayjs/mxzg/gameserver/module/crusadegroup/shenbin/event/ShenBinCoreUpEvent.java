package com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.event;

import lombok.Value;

import java.util.Map;

/**
 * 神兵核心升级
 */
@Value(staticConstructor = "of")
public class ShenBinCoreUpEvent {
    private long rid;
    //key:job  value:coreLv
    private Map<Integer,Integer> jobCoreMap;
}
