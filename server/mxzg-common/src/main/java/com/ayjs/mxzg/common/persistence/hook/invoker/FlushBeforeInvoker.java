package com.ayjs.mxzg.common.persistence.hook.invoker;

import com.ayjs.mxzg.common.persistence.hook.FlushBefore;
import org.springframework.stereotype.Component;

@Component
public class FlushBeforeInvoker implements HookInvoker<FlushBefore> {

    @Override
    public boolean invoke(FlushBefore entity) {
        return entity.flushBefore();
    }
}
