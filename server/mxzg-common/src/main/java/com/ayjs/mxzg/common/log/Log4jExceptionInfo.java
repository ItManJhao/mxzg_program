package com.ayjs.mxzg.common.log;

/**
 * 异常信息
 */
public class Log4jExceptionInfo {
    /**
     * 服务器id
     */
    private int sid;
    /**
     * 角色id
     */
    private long rid;
    /**
     * 异常类
     */
    private String exceptionName = "";
    /**
     * 类名
     */
    private String className = "";
    /**
     * 方法
     */
    private String methodName = "";
    /**
     * 异常行数
     */
    private int lineNumber;
    /**
     * 异常消息
     */
    private String message = "";
    /**
     * 时间戳
     */
    private int time;
    /**
     * 堆栈信息
     */
    private String stackTrace = "";

    Log4jExceptionInfo(int sid, long rid, String exceptionName, String className, String methodName, int lineNumber, String message, int time, String stackTrace) {
        this.sid = sid;
        this.rid = rid;
        this.exceptionName = exceptionName;
        this.className = className;
        this.methodName = methodName;
        this.lineNumber = lineNumber;
        this.message = message;
        this.time = time;
        this.stackTrace = stackTrace;
    }

    public static Log4jExceptionInfoBuilder builder() {
        return new Log4jExceptionInfoBuilder();
    }

    public String toString() {
        return "Log4jExceptionInfo(sid=" + this.sid + ", rid=" + this.rid + ", exceptionName=" + this.exceptionName + ", className=" + this.className + ", methodName=" + this.methodName + ", lineNumber=" + this.lineNumber + ", message=" + this.message + ", time=" + this.time + ", stackTrace=" + this.stackTrace + ")";
    }

    public static class Log4jExceptionInfoBuilder {
        private int sid;
        private long rid;
        private String exceptionName = "";
        private String className = "";
        private String methodName = "";
        private int lineNumber;
        private String message = "";
        private int time;
        private String stackTrace = "";

        Log4jExceptionInfoBuilder() {
        }

        public Log4jExceptionInfo.Log4jExceptionInfoBuilder sid(int sid) {
            this.sid = sid;
            return this;
        }

        public Log4jExceptionInfo.Log4jExceptionInfoBuilder rid(long rid) {
            this.rid = rid;
            return this;
        }

        public Log4jExceptionInfo.Log4jExceptionInfoBuilder exceptionName(String exceptionName) {
            this.exceptionName = exceptionName;
            return this;
        }

        public Log4jExceptionInfo.Log4jExceptionInfoBuilder className(String className) {
            this.className = className;
            return this;
        }

        public Log4jExceptionInfo.Log4jExceptionInfoBuilder methodName(String methodName) {
            this.methodName = methodName;
            return this;
        }

        public Log4jExceptionInfo.Log4jExceptionInfoBuilder lineNumber(int lineNumber) {
            this.lineNumber = lineNumber;
            return this;
        }

        public Log4jExceptionInfo.Log4jExceptionInfoBuilder message(String message) {
            this.message = message;
            return this;
        }

        public Log4jExceptionInfo.Log4jExceptionInfoBuilder time(int time) {
            this.time = time;
            return this;
        }

        public Log4jExceptionInfo.Log4jExceptionInfoBuilder stackTrace(String stackTrace) {
            this.stackTrace = stackTrace;
            return this;
        }

        public Log4jExceptionInfo build() {
            return new Log4jExceptionInfo(sid, rid, exceptionName, className, methodName, lineNumber, message, time, stackTrace);
        }

        public String toString() {
            return "Log4jExceptionInfo.Log4jExceptionInfoBuilder(sid=" + this.sid + ", rid=" + this.rid + ", exceptionName=" + this.exceptionName + ", className=" + this.className + ", methodName=" + this.methodName + ", lineNumber=" + this.lineNumber + ", message=" + this.message + ", time=" + this.time + ", stackTrace=" + this.stackTrace + ")";
        }
    }
}
