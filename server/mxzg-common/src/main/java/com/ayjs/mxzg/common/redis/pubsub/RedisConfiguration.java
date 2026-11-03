package com.ayjs.mxzg.common.redis.pubsub;

import com.alibaba.fastjson.support.spring.GenericFastJsonRedisSerializer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.data.redis.listener.adapter.MessageListenerAdapter;

@Configuration
public class RedisConfiguration {

    // 初始化监听器
    @Bean
    public RedisMessageListenerContainer container(RedisConnectionFactory connectionFactory, MessageListenerAdapter listener) {
        RedisMessageListenerContainer container = new RedisMessageListenerContainer();
        container.setConnectionFactory(connectionFactory);
        container.addMessageListener(listener, new ChannelTopic(RedisChannelTopic.CHAT_ALL));
        return container;
    }

    // 监听处理
    @Bean
    public MessageListenerAdapter listenerAdapter(RedisMessageReceiver messageReceiver) {
        MessageListenerAdapter listener = new MessageListenerAdapter(messageReceiver);
        GenericFastJsonRedisSerializer serializer = new GenericFastJsonRedisSerializer();
        listener.setSerializer(serializer);
        return listener;
    }

}
