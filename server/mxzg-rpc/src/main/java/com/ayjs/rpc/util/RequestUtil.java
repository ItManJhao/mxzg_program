package com.ayjs.rpc.util;

import com.ayjs.rpc.RemoteMessage;
import com.ayjs.rpc.client.Request;
import com.ayjs.rpc.exception.ServiceNameFormatException;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class RequestUtil {

    public static String[] checkServiceName(String serviceName) {
        String[] result = serviceName.split("\\.");
        if (result.length != 2) {
            throw new ServiceNameFormatException("The format of service name is wrong.");
        }
        return result;
    }

    public static Request createRequest(RemoteMessage message) {
        Request result = new Request();
        result.setMessage(message);
        return result;
    }

    public static Request createAndSetRequestId(RemoteMessage message) {
        Request result = new Request();
        result.setMessage(message);
        result.incrementRequestId();
        return result;
    }
}
