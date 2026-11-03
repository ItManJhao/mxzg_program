package com.ayjs.mxzg.common.persistence.hook.invoker;

import com.ayjs.mxzg.common.persistence.hook.GetAfter;
import org.springframework.stereotype.Component;

@Component
public class GetAfterInvoker implements HookInvoker<GetAfter> {

    @Override
    public boolean invoke(GetAfter entity) {
        return entity.getAfter();
    }
}
