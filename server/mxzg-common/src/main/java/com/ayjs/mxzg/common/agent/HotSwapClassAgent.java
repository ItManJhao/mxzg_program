package com.ayjs.mxzg.common.agent;

import lombok.extern.slf4j.Slf4j;

import java.io.UnsupportedEncodingException;
import java.lang.instrument.Instrumentation;
import java.net.URL;
import java.net.URLDecoder;

/**
 *
 */
@Slf4j
public class HotSwapClassAgent {
    private volatile static Instrumentation instrumentation;
    private static Object locker = new Object();

    private HotSwapClassAgent() {
    }

    public static void agentmain(String args, Instrumentation inst) {
        if (instrumentation == null) {
            synchronized (locker) {
                if (instrumentation == null) {
                    instrumentation = inst;
                    System.out.println("JavaDynamicAgent.agentmain 初始化");
                }
            }
        }

    }

    public static Instrumentation getInstrumentation() {
        return instrumentation;
    }

    public static String currentJarPath() {
        URL url = HotSwapClassAgent.class.getProtectionDomain().getCodeSource().getLocation();
        return decodeArg(url.getPath());
//        URI uri = null;
//
//        try {
//            System.out.println("url:"+ url.getPath());
//            System.out.println("decodeArg url:"+ decodeArg(url.getPath()));
//            uri = url.toURI();
//        } catch (Exception var3) {
//            throw new RuntimeException(var3.getMessage(), var3);
//        }
//        System.out.println("uri:" + uri);VirtualMachine
//        System.out.println("decodeArg uri:" + decodeArg(uri.getPath()));
//        File file = new File(uri);
//        return file.getAbsolutePath();
    }

    private static String decodeArg(String arg) {
        try {
            return URLDecoder.decode(arg, "utf-8");
        } catch (UnsupportedEncodingException e) {
            log.error(e.getMessage(), e);
            return arg;
        }
    }
}
