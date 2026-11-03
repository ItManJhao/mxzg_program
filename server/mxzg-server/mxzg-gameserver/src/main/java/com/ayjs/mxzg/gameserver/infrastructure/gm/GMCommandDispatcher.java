package com.ayjs.mxzg.gameserver.infrastructure.gm;

import com.ayjs.mxzg.common.base.SpringProxy;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Component
public class GMCommandDispatcher implements Lifecycle {

    private Map<String, GMCommandInvoker> invokers = new HashMap<>();

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.LOW, Ordinal._47, "GM COMMAND DISPATCHER");
    }

    @Override
    public void start() throws Exception {

        Collection<ProtocolHandler> handlers = SpringProxy.getBeansOfType(ProtocolHandler.class);
        handlers.stream().forEach(protocolHandler -> {
            Method[] methods = protocolHandler.getClass().getDeclaredMethods();
            for (Method method : methods) {
                GMCommand command = method.getAnnotation(GMCommand.class);
                if (command == null) {
                    continue;
                }
                //重复注册
                if (invokers.containsKey(command.command())) {
                    log.error("重复定义:{}.{} {}", protocolHandler.getClass().getSimpleName()
                            , method.getName(), command.command());
                }
                try {
                    invokers.put(command.command(), new GMCommandInvoker(command.command(), protocolHandler, method));
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }

    public GMCommandInvoker getInvoker(String cmd) {
        return invokers.get(cmd);
    }
}
