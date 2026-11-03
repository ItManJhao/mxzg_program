package com.ayjs.rpc.server;

import lombok.Value;

import java.lang.reflect.Method;
import java.util.Arrays;

/**
 * Created by LeiJun on 2018/6/20.
 */
@Value(staticConstructor = "of")
public class ServiceProviderContext {

    private final Object provider;
    private final Method providerMethod;
    private final Object[] args;

    public String exceptionMessage() {
        Method method = providerMethod;
        StringBuilder sb = new StringBuilder();
        sb.append("Exception thrown by provider method ")
                .append(method.getName())
                .append('(');
        separateWithCommas(method.getParameterTypes(), sb);
        sb.append(')')
                .append(" on provider ")
                .append(provider)
                .append(" when provide service, args:")
                .append(Arrays.toString(args));
        return sb.toString();
    }

    public String methodMessage() {
        Method method = providerMethod;
        StringBuilder sb = new StringBuilder();
        sb.append("Method ")
                .append(method.getName())
                .append('(');
        separateWithCommas(method.getParameterTypes(), sb);
        sb.append(')')
                .append(" on provider ")
                .append(provider)
                .append(" when provide service, args:")
                .append(Arrays.toString(args));
        return sb.toString();
    }

    private void separateWithCommas(Class<?>[] types, StringBuilder sb) {
        for (int j = 0; j < types.length; j++) {
            sb.append(types[j].getName());
            if (j < (types.length - 1))
                sb.append(", ");
        }
    }
}
