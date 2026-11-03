package com.ayjs.rpc.dispatcher;

import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.rpc.RemoteMessage;
import com.ayjs.rpc.client.Client;
import com.ayjs.rpc.client.ClientHolder;
import com.ayjs.rpc.client.Request;
import com.ayjs.rpc.client.ResponseFuture;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.function.Consumer;

/**
 * 消息派发器
 * @author meiyc
 *
 */
@Component
public class MessageDispatcher {

	@Autowired
	private ConsumerHolder consumerHolder;
	@Autowired
	private ClientHolder clientHolder;

	/**
	 * 派发消息
	 * @param message
	 */
	public <T extends RemoteMessage> void dispatch(T message){
		Client<?> client = clientHolder.getOfType(message.getClass());
        Asserts.notNull(client.rpcClient(), 34501, String.format("跨服链接已经断开%s", message.getClass()));
        client.rpcClient().send(message);
	}
	
	/**
	 * 异步派发消息并回调结果，消息只发送给第一个连接
	 * @param message
	 * @param consumer 返回的结果
	 */
    public <T extends RemoteMessage, V> void dispatch(T message, Consumer<V> consumer) {
		Client<?> client = clientHolder.getOfType(message.getClass());
        Asserts.notNull(client.rpcClient(), 34501, String.format("跨服链接已经断开%s", message.getClass()));
        Request request = client.rpcClient().sendAndMark(message);
        consumerHolder.addConsumer(request.getRequestId(), consumer, null);
	}

	/**
	 * 异步派发消息并回调结果，消息只发送给第一个连接
	 * @param message
	 * @param success	返回的结果
	 * @param fail 这里回调对象为null，暂时占位
	 */
	public <T extends RemoteMessage, V> void dispatch(T message, Consumer<V> success, Consumer<V> fail) {
		try {
			Client<?> client = clientHolder.getOfType(message.getClass());
			Asserts.notNull(client.rpcClient(), 34501, String.format("跨服链接已经断开%s", message.getClass()));
			Request request = client.rpcClient().sendAndMark(message);
			consumerHolder.addConsumer(request.getRequestId(), success, fail);
		} catch (Exception ex){
			fail.accept(ConvertUtils.cast(ex));
			throw ex;
		}
	}

	/**
	 * 派发消息，并同步等待结果返回
	 * @param message
	 * @return
	 */
	public <T extends RemoteMessage, V> V syncDispatch(T message) {
        Client<?> client = clientHolder.getOfType(message.getClass());
        Asserts.notNull(client.rpcClient(), 34501, String.format("跨服链接已经断开%s", message.getClass()));
        ResponseFuture<?> future = client.rpcClient().call(message);
        return ConvertUtils.cast(future.get());
	}
	
}
