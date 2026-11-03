package com.ayjs.rpc.exception;

public class NoSuchServerException extends RuntimeException {

    private static final long serialVersionUID = -2701338253669046805L;

    private final String className;
    private final String methodName;

    public NoSuchServerException(String className, String methodName) {
        super("No server " + className + "." + methodName);
        this.className = className;
        this.methodName = methodName;
    }

    public String getClassName() {
        return className;
    }

    public String getMethodName() {
        return methodName;
    }
}
