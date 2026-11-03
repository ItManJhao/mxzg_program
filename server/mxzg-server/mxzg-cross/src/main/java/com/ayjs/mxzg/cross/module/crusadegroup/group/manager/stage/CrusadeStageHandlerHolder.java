package com.ayjs.mxzg.cross.module.crusadegroup.group.manager.stage;

import com.ayjs.mxzg.common.holder.AbstractHolder;
import com.ayjs.mxzg.config.struct.CrusadeGroupStage;
import org.springframework.stereotype.Component;

@Component
public class CrusadeStageHandlerHolder extends AbstractHolder<CrusadeGroupStage, CrusadeStageHandler> {
    @Override
    protected CrusadeGroupStage convert(CrusadeStageHandler bean) {
        return bean.getStage();
    }
}
