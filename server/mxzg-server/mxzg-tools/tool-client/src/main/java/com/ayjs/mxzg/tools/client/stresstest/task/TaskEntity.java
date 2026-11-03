package com.ayjs.mxzg.tools.client.stresstest.task;

import com.google.protobuf.Message;
import lombok.Getter;
import lombok.ToString;

/**
 * 测试任务
 *
 * @author tangyangbo 2019/8/30 20:52
 */
@Getter
@ToString
public class TaskEntity {
    /**
     * 当前任务执行的的协议号
     */
    private int cmdId;
    /**
     * 延迟的毫秒
     */
    private long requestTime;
    /**
     * 消息体
     */
    private Message.Builder messageBuilder;

    public TaskEntity() {
    }

    public TaskEntity(int cmdId, long requestTime, Message.Builder messageBuilder) {
        this.cmdId = cmdId;
        this.requestTime = requestTime;
        this.messageBuilder = messageBuilder;
    }
}
