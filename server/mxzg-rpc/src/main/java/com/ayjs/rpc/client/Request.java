package com.ayjs.rpc.client;

import com.ayjs.rpc.RemoteMessage;
import com.ayjs.rpc.RpcMessage;
import lombok.Getter;
import lombok.Setter;

import java.util.concurrent.atomic.AtomicLong;

/**
 * 请求
 *
 * @author Alias
 * @date 2017年11月10日 下午1:53:52
 */
@Setter
@Getter
public class Request implements RpcMessage {

    private static final AtomicLong reqSequence = new AtomicLong();

    /** 请求序列号 */
    private long requestId;
    /** 消息对象 */
    private RemoteMessage message;

    /**
     * 自增长请求id
      */
    public void incrementRequestId(){
        this.requestId = reqSequence.incrementAndGet();
    }

    /**
     * 该请求是否要等待结果
     * @return
     */
    public boolean isWaitingResult(){
        return requestId > 0;
    }
    
    @Override
    public String toString() {
        return "Request [classId=" + message.getClass() + ", requestId=" + requestId + "]";
    }

    public RemoteMessage getMessage() {
        return message;
    }

}
