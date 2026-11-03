package com.ayjs.rpc.server;

import com.ayjs.mxzg.common.util.SymbolConstants;
import com.ayjs.rpc.RemoteMessage;
import com.ayjs.rpc.client.Request;
import com.ayjs.rpc.client.ResponseFuture;
import com.ayjs.rpc.client.RpcContext;
import com.ayjs.rpc.util.InstanceFactory;
import com.ayjs.rpc.util.RequestUtil;
import io.netty.channel.Channel;

import java.util.Objects;

/**
 * TCP连接
 *
 * @author Alias
 * @date 2017年12月11日 下午4:07:52
 */
public class Connection {

    private Channel channel;

    private int clientId;

    public Connection(Channel channel) {
        this.channel = channel;
    }

    public int getClientId() {
        return clientId;
    }

    public void setClientId(int clientId) {
        this.clientId = clientId;
    }

    /**
     * 响应消息
     *
     * @param msg
     */
    public void sendResponse(Object msg) {
        Object result = msg;
        if (!(msg instanceof Response)) {
            Response response = new Response();
            response.setResult(msg);
            result = response;
        }
        channel.writeAndFlush(result);
    }

    /**
     * 回调响应
     * @param response
     */
    public void callbackResponse(Response response){
        if(channel != null){
            channel.writeAndFlush(response);
        }
    }

    /**
     * 转发请求
     *
     * @param request
     */
    public void forwardRequest(Request request) {
        if (this.channel != null) {
            this.channel.writeAndFlush(request);
        }
    }

    public Channel getChannel() {
        return channel;
    }

    /**
     * 断开连接
     */
    public void close() {
        if (this.channel != null && !this.channel.isActive()) {
            this.channel.close();
        }
    }

    /**
     * 发送消息
     *
     * @param message
     */
    public void send(RemoteMessage message) {
        Request request = RequestUtil.createRequest(message);
        if (this.channel != null) {
            this.channel.writeAndFlush(request);
        }
    }

    @SuppressWarnings("unchecked")
	public <T> ResponseFuture<T> call(RemoteMessage message) {
        Request request = RequestUtil.createRequest(message);
        ResponseFuture<T> future = new ResponseFuture<>(request);
        InstanceFactory.getInstance(RpcContext.class).addCallback(future);
        if (this.channel != null) {
            this.channel.writeAndFlush(request);
        }
        return future;
    }

    public String getRemoteAddress() {
        if (Objects.isNull(channel) || Objects.isNull(channel.remoteAddress())) {
            return SymbolConstants.EMPTY;
        }
        // channel.remoteAddress会得到ip+port，形如/192.168.0.1:12345
        String address = channel.remoteAddress().toString().replace(SymbolConstants.SLASH, SymbolConstants.EMPTY);
        return address.substring(0, address.indexOf(SymbolConstants.COLON));
    }

}
