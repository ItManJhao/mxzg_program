package com.ayjs.mxzg.gameserver.module.targetCounter.counter;

import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;

/**
 * @Author: CWJ
 * @Date: 2019/10/28
 **/
public interface Counter {

    TargetType thisType();

    /**
     * 计算玩家当前状态值
     *
     * @param rid
     * @param targetStruct
     * @return
     */
    int count(long rid, TargetStruct targetStruct);

    /***
     * 计算玩家值
     * @param rid
     * @param targetStruct
     * @return
     */
     long taskCount(long rid, TargetStruct targetStruct) ;
}
