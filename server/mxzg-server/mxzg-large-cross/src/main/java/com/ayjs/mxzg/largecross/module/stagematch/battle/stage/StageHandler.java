package com.ayjs.mxzg.largecross.module.stagematch.battle.stage;

import com.ayjs.mxzg.config.excel.entity.CSuperStageCycle;
import com.ayjs.mxzg.config.struct.StageType;

/**
 * 阶段处理器
 */
public interface StageHandler {

    /**
     * 获取阶段类型
     * @return
     */
    StageType getType();

    /**
     * 处理阶段
     * @param cycle
     */
    void handle(CSuperStageCycle cycle);

}
