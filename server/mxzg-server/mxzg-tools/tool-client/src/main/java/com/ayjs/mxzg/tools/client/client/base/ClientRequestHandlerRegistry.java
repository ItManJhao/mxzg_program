package com.ayjs.mxzg.tools.client.client.base;

import com.ayjs.mxzg.common.util.scanner.PackageScanner;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.reflect.TypeUtils;

import java.lang.reflect.Method;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 客户端请求处理
 *
 * @author tangyangbo 2019/9/6 18:13
 */
@Slf4j
public class ClientRequestHandlerRegistry {

    public static Map<Integer, ClientRequestHandler> map = new ConcurrentHashMap<>();

    public static ClientRequestHandler defaultClientRequestHandler = new DefaultClientRequestHandler();

    public static void init() {
        Set<Class<ClientRequestHandler>> classes = PackageScanner.scanPackages(
                clazz -> TypeUtils.isAssignable(clazz, ClientRequestHandler.class), BaseConfig.SCAN_PACKAGE_NAME_TOOL);

        classes.forEach(clazz -> {
            try {
                if (clazz != ClientRequestHandler.class) {
                    Method getMessageId = clazz.getDeclaredMethod("getMessageId");
                    ClientRequestHandler handler = clazz.newInstance();
                    Object messageId = getMessageId.invoke(handler);
                    map.put(Integer.valueOf(messageId.toString()), handler);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
        log.debug("Client Request Handler Registry size:{}", map.size());
    }

    public static ClientRequestHandler getHandler(int messageId) {
        return map.getOrDefault(messageId, defaultClientRequestHandler);
    }
}
