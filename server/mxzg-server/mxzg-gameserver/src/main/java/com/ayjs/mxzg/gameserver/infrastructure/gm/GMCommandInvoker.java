package com.ayjs.mxzg.gameserver.infrastructure.gm;

import lombok.Getter;

import java.lang.reflect.Method;

@Getter
public class GMCommandInvoker {
    /**
     * 协议ID
     */
    private String command;
    /**
     * 调用方法的实例，即对应函数所在类的实例
     */
    private Object invoker;
    /**
     * 协议处理函数
     */
    private Method method;

    public GMCommandInvoker(String command, Object invoker, Method method) {
        this.command = command;
        this.invoker = invoker;
        this.method = method;
    }
}
