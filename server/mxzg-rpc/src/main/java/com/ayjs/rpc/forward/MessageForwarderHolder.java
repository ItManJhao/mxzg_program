package com.ayjs.rpc.forward;

import com.ayjs.mxzg.common.holder.AbstractArgumentTypeHolder;
import com.ayjs.mxzg.common.util.TypeUtils;
import com.ayjs.rpc.RemoteMessage;
import com.ayjs.rpc.client.Request;
import com.ayjs.rpc.server.Connection;
import com.ayjs.rpc.server.ConnectionManager;
import com.ayjs.rpc.server.Response;
import com.google.common.collect.HashBasedTable;
import com.google.common.collect.Table;
import com.google.common.collect.Tables;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import java.util.Collection;
import java.util.Set;

/**
 * 消息转发持有者
 */
@Component
public class MessageForwarderHolder extends AbstractArgumentTypeHolder<MessageForwarder<?>> {

    @Autowired
    private ConnectionManager connectionManager;

    /** 转发的请求映射Table<TargetClientId, RequestId, SourceClientId>
     *
     * */
    private Table<Integer, Long, Integer> responseWaitingTable = Tables.synchronizedTable(HashBasedTable.create());

    /**
     * 尝试转发消息，被转发成功的消息不需要在本地执行
     *
     * @param request
     * @param connection
     * @return 转发是否成功
     */
    public boolean tryForwardRequest(Request request, Connection connection) {
        Set<Class<?>> types = this.beanMapping.keySet();
        boolean success = false;
        RemoteMessage remoteMessage = request.getMessage();
        for (Class<?> type : types) {
            if (TypeUtils.isInstance(remoteMessage, type)) {
                MessageForwarder<?> forwarder = getOfType(type);
                Collection<Integer> clientIds = forwarder.forward(request, connection);
                if(request.isWaitingResult() && !CollectionUtils.isEmpty(clientIds)){
                    for (Integer clientId : clientIds) {
                        this.responseWaitingTable.put(clientId, request.getRequestId(), connection.getClientId());
                    }
                }
                success = true;
                break;
            }
        }
        return success;
    }

    /**
     * 尝试回调响应
     * @param response
     * @param connection
     * @return
     */
    public boolean tryForwardResponse(Response response, Connection connection){
        Integer sourceClientId = this.responseWaitingTable.remove(connection.getClientId(), response.getRequestId());
        if(sourceClientId == null){
            return false;
        }
        connectionManager.forwardResponse(sourceClientId, response);
        return true;
    }

}
