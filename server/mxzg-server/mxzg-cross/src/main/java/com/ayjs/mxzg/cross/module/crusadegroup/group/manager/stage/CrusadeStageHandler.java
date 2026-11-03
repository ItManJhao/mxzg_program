package com.ayjs.mxzg.cross.module.crusadegroup.group.manager.stage;

import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupCycle;
import com.ayjs.mxzg.config.struct.CrusadeGroupStage;

/**
 * 讨伐团阶段处理器
 */
public interface CrusadeStageHandler {

    /**
     * 获取阶段
     * @return
     */
    CrusadeGroupStage getStage();

    /**
     * 处理阶段
     * @param startCycle
     */
    void handle(CCrusadeGroupCycle startCycle);

}
