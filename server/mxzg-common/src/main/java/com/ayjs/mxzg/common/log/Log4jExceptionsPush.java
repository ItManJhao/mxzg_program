package com.ayjs.mxzg.common.log;

import cn.hutool.http.HttpUtil;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.core.LogEvent;
import org.apache.logging.log4j.util.ReadOnlyStringMap;
import org.slf4j.Logger;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * log4j异常
 */
public class Log4jExceptionsPush {

    private static final Log4jExceptionsPush instance = new Log4jExceptionsPush();
    private static final Logger log = org.slf4j.LoggerFactory.getLogger(Log4jExceptionsPush.class);
    /**
     * 异步日志事件处理器
     */
    private ScheduledExecutorService executor = null;
    /**
     * 推送地址
     */
    private String push_url = "";
    /**
     * 服务器id
     */
    private int sid;
    /**
     * 堆栈需要过滤的包名，需要全部堆栈填空
     */
    private String packageName = "";
    /**
     * 待发送队列
     */
    private ConcurrentLinkedQueue<Log4jExceptionInfo> queue;

    private Log4jExceptionsPush() {
    }

    public static Log4jExceptionsPush getInstance() {
        return instance;
    }

    public void init(int sid, String pushUrl, String packageName, ScheduledExecutorService executor) {
        this.queue = new ConcurrentLinkedQueue<>();
        this.push_url = pushUrl;
        this.sid = sid;
        this.packageName = packageName;
        this.executor = executor;
    }

    public void start() {
        executor.scheduleWithFixedDelay(() -> {
            try {
                List<Log4jExceptionInfo> list = new ArrayList<>();
                Log4jExceptionInfo logInfo = null;

                while ((logInfo = queue.poll()) != null && list.size() < 100) {
                    list.add(logInfo);
                }
                pushLogs(list);
            } catch (Exception e) {
                e.printStackTrace();
            }

        }, 10000, 8000, TimeUnit.MILLISECONDS);
    }

    public void pushLogs(List<Log4jExceptionInfo> logs) {
        if (CollectionUtils.isEmpty(logs)) {
            return;
        }
        try {
            Map<String, Object> logsMap = new HashMap<>();
            logsMap.put("data", GsonUtils.toJson(logs));
            String post = HttpUtil.post(push_url, logsMap, 5000);
            log.debug("push log exception :{}", post);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 是否能够推送
     *
     * @param event
     * @return
     */
    public boolean canPush(LogEvent event) {
        return Objects.isNull(event) ||
                StringUtils.isBlank(push_url) ||
                !Objects.nonNull(queue) ||
                !Level.ERROR.equals(event.getLevel());
    }

    public void add(LogEvent event) {
        if (canPush(event)) {
            return;
        }
        Log4jExceptionInfo logInfo = logEventToLogInfo(event);
        if (Objects.nonNull(logInfo)) {
            queue.offer(logInfo);
        }
    }

    public Log4jExceptionInfo logEventToLogInfo(LogEvent event) {
        if (canPush(event)) {
            return null;
        }
        final Throwable thrown = event.getThrown();
        if (Objects.isNull(thrown)) {
            return null;
        }
        Log4jExceptionInfo.Log4jExceptionInfoBuilder builder = Log4jExceptionInfo.builder();
        builder.message(thrown.getMessage());
        builder.sid(this.sid);
        builder.time(DateTimeUtil.currentSecond());

        StackTraceElement[] stackTrace = thrown.getStackTrace();

        Throwable cause = thrown.getCause();
        if (cause != null) {
            builder.exceptionName(cause.getClass().getName());

            StackTraceElement[] causeStackTrace = cause.getStackTrace();
            if (causeStackTrace != null && causeStackTrace[0] != null) {
                stackTrace = causeStackTrace;
            }
        } else {
            builder.exceptionName(thrown.getClass().getName());
        }
        if (stackTrace != null && stackTrace[0] != null) {
            StackTraceElement stackTraceElement = stackTrace[0];
            builder.className(stackTraceElement.getClassName());
            builder.methodName(stackTraceElement.getMethodName());
            builder.lineNumber(stackTraceElement.getLineNumber());
        }
        // 记录部分堆栈
        if (stackTrace != null) {
            List<String> stackTraceElements = new ArrayList<>();
            for (int i = 0; i < stackTrace.length; i++) {
                StackTraceElement traceElement = stackTrace[i];
                if (Objects.isNull(traceElement)) {
                    continue;
                }
                String traceStr = traceElement.toString();
                if (i >= 2 && (StringUtil.isNotBlank(packageName) && !traceStr.contains(packageName))) {
                    continue;
                }
                stackTraceElements.add(traceStr);
            }
            builder.stackTrace(StringUtil.join("\n", stackTraceElements));
        }
        // 记录日志透传参数rid
        ReadOnlyStringMap contextData = event.getContextData();
        if (Objects.nonNull(contextData)) {
            String ridStr = ConvertUtils.toString(contextData.getValue("rid"));
            if (Objects.nonNull(ridStr)) {
                ridStr = ridStr.substring(ridStr.indexOf("=") + 1);
                long rid = ConvertUtils.toLong(ridStr);
                builder.rid(rid);
            }
        }
        return builder.build();
    }
}
