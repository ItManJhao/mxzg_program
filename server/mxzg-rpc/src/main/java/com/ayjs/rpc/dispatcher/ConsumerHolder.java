package com.ayjs.rpc.dispatcher;

import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.util.TypeUtils;
import com.ayjs.rpc.DefaultResultMessage;
import com.ayjs.rpc.ErrorResultMessage;
import com.ayjs.rpc.forward.MessageForwarderHolder;
import com.ayjs.rpc.server.Connection;
import com.ayjs.rpc.server.Response;
import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.RemovalListener;
import com.google.common.cache.RemovalNotification;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;
import java.util.function.Consumer;

/**
 * 消费者持有者
 * @author meiyc
 *
 */
@Slf4j
@Component
public class ConsumerHolder {

	@Autowired
	private MessageForwarderHolder forwarderHolder;

	/** 成功消费者 */
	private Cache<Long, Consumer<?>> cache = CacheBuilder.newBuilder()
			.maximumSize(1000)
			.expireAfterAccess(5, TimeUnit.SECONDS)
			.build();

	/** 失败消费者 */
	private Cache<Long, Consumer<?>> failCache = CacheBuilder.newBuilder()
			.maximumSize(1000)
			.expireAfterAccess(2, TimeUnit.SECONDS)
			.removalListener(new RemovalListener<Long, Consumer<?>>(){
				@Override
				public void onRemoval(RemovalNotification<Long, Consumer<?>> notification) {
					notification.getValue().accept(null);
				}
			})
			.build();
	
	/**
	 * 添加一个消费者
	 * @param id
	 * @param success
	 * @param fail
	 */
	public void addConsumer(Long id, Consumer<?> success, Consumer<?> fail){
		cache.put(id, success);
		if(fail != null){
			failCache.put(id, fail);
		}
	}
	
	/**
	 * 获取成功消费者
	 * @param id
	 * @return
	 */
	public Consumer<?> getConsumer(Long id){
		return cache.getIfPresent(id);
	}

	/**
	 * 获取失败消费者
	 * @param id
	 * @return
	 */
	public Consumer<?> getFailConsumer(Long id){
		return cache.getIfPresent(id);
	}

    /**
     * 移除
     * @param id
     */
	public void remove(Long id){
        cache.asMap().remove(id);
        failCache.asMap().remove(id);
    }

    /**
     * 消费响应
     *
     * @param response
     */
    public void consume(Response response, Connection connection) {
		if(forwarderHolder.tryForwardResponse(response, connection)){
			return;
		}

        Consumer<?> consumer = getConsumer(response.getRequestId());
        if (consumer != null) {
            Object result = response.getResult();
            if(TypeUtils.isInstance(result, ErrorResultMessage.class)){
				Consumer<?> fail = getFailConsumer(response.getRequestId());
				if(fail != null){
					fail.accept(null);
				}

				if (TypeUtils.isInstance(result, DefaultResultMessage.class)) {
					DefaultResultMessage error = (DefaultResultMessage)result;
                    log.info("预期消息类型为{}的请求远程服务器处理失败", error.getReturnType());
				}
			} else {
				consumer.accept(ConvertUtils.cast(result));
			}

            remove(response.getRequestId());
        } else {
            log.info("No such request:", response.getRequestId());
        }

    }

}
