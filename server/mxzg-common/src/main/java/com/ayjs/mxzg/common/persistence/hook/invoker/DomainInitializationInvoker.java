package com.ayjs.mxzg.common.persistence.hook.invoker;

import com.ayjs.mxzg.common.persistence.hook.DomainInitialization;
import org.springframework.stereotype.Component;

@Component
public class DomainInitializationInvoker implements HookInvoker<DomainInitialization> {

    @Override
    public boolean invoke(DomainInitialization entity) {
        entity.initialize();
        return false;
    }
}
