package com.ayjs.mxzg.tools.client.client.base;

import com.ayjs.mxzg.common.util.scanner.PackageScanner;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.reflect.TypeUtils;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/**
 * Handler注册
 *
 * @author tangyangbo 2019/9/2 21:16
 */
@Slf4j
public class ClientResponseHandlerRegistry {

    public static Map<Integer, ClientResponseHandler> map = new HashMap<>();

    public static void init() {
        Set<Class<ClientResponseHandler>> classes = PackageScanner.scanPackages(
                clazz -> TypeUtils.isAssignable(clazz, ClientResponseHandler.class), BaseConfig.SCAN_PACKAGE_NAME_TOOL);

        classes.forEach(clazz -> {
            try {
                if (clazz != ClientResponseHandler.class) {
                    Method getMessageId = clazz.getDeclaredMethod("getMessageId");
                    ClientResponseHandler handler = clazz.newInstance();
                    Object messageId = getMessageId.invoke(handler);
                    map.put(Integer.valueOf(messageId.toString()), handler);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
        log.debug("Handler Registry size:{}", map.size());
    }

    public static ClientResponseHandler getHandler(int messageId) {
        return map.get(messageId);
    }

}
