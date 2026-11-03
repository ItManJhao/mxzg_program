package com.ayjs.mxzg.largecross.module.stagematch.battle.stage;

import com.ayjs.mxzg.common.holder.AbstractHolder;
import com.ayjs.mxzg.config.struct.StageType;
import org.springframework.stereotype.Component;

/**
 * 阶段处理器持有者
 */
@Component
public class StageHandlerHolder extends AbstractHolder<StageType, StageHandler> {

    @Override
    protected StageType convert(StageHandler bean) {
        return bean.getType();
    }
}
