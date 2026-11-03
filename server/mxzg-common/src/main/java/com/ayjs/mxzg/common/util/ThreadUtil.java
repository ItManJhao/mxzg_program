package com.ayjs.mxzg.common.util;

/**
 * 线程工具
 */
public class ThreadUtil {

    public static StackTraceElement[] getStackTrace() {
        return Thread.currentThread().getStackTrace();
    }

    public static String getStackTraceToStr() {
        StringBuilder err = new StringBuilder();
        StackTraceElement[] stackTrace = getStackTrace();
        for (int i = 0; i < stackTrace.length; i++) {
            err.append("\tat ");
            err.append(stackTrace[i].toString());
            err.append("\n");
        }
        return err.toString();
    }

    public static String getCurrentPackageStackTraceToStr() {
        StringBuilder err = new StringBuilder();
        StackTraceElement[] stackTrace = getStackTrace();
        for (int i = 0; i < stackTrace.length; i++) {
            String stack = stackTrace[i].toString();
            if (stack.contains("com.ayjs.mxzg")) {
                err.append("\tat ");
                err.append(stack);
                err.append("\n");
            }
        }
        return err.toString();
    }
}
