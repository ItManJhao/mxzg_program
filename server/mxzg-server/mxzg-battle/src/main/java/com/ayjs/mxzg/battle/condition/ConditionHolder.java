package com.ayjs.mxzg.battle.condition;

import com.ayjs.mxzg.battle.model.ConditionType;
import com.ayjs.mxzg.common.holder.AbstractHolder;
import org.springframework.stereotype.Component;

@Component
public class ConditionHolder extends AbstractHolder<ConditionType, ConditionChecker> {
    @Override
    protected ConditionType convert(ConditionChecker bean) {
        return bean.type();
    }
}
