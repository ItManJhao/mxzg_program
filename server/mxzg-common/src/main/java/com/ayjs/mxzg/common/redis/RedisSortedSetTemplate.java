package com.ayjs.mxzg.common.redis;

import com.ayjs.mxzg.common.function.MoreObjects;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.data.redis.serializer.StringRedisSerializer;

import java.util.Collection;
import java.util.Set;

/**
 *
 */
public class RedisSortedSetTemplate<K, T extends SortedEntity<K>> {

    private final RedisTemplate<String, K> redisTemplate;

    private final String keyName;

    public RedisSortedSetTemplate(String keyName, Class<K> idType, RedisConnectionFactory connectionFactory) {
        this.redisTemplate = buildRedisTemplate(idType, connectionFactory);
        this.keyName = keyName + "_sorted_set";
    }

    private RedisTemplate<String, K> buildRedisTemplate(Class<K> idType, RedisConnectionFactory connectionFactory) {
        RedisTemplate<String, K> template = new RedisTemplate<>();
        template.setConnectionFactory(connectionFactory);
        template.setKeySerializer(new StringRedisSerializer());
        template.setValueSerializer(new FastJsonRedisSerializer<>(idType));
        template.afterPropertiesSet();
        return template;
    }

    public long size() {
        return MoreObjects.firstNonNull(redisTemplate.opsForZSet().size(this.keyName), 0L);
    }

    public Set<K> listAll() {
        return redisTemplate.opsForZSet().range(keyName, 0, -1);
    }

    public void add(T entity) {
        redisTemplate.opsForZSet().add(this.keyName, entity.getId(), entity.getScore());
    }

    public void add(Collection<T> entities) {
        entities.forEach(this::add);
    }

    public void remove(T entity) {
        redisTemplate.opsForZSet().remove(this.keyName, entity.getId());
    }

    public void remove(Collection<T> entities) {
        redisTemplate.opsForZSet().remove(this.keyName, entities.stream().map(SortedEntity::getId).toArray());
    }

    public void removeAll() {
        redisTemplate.delete(this.keyName);
    }

    public void update(T entity) {
        add(entity);
    }

    public void update(Collection<T> entities) {
        add(entities);
    }

    public Set<K> rangeByScore(double min, double max) {
        return redisTemplate.opsForZSet().rangeByScore(keyName, min, max);
    }

    public Set<K> range(long start, long end) {
        return redisTemplate.opsForZSet().range(keyName, start, end);
    }

    public Set<ZSetOperations.TypedTuple<K>> rangeWithScores(long start, long end) {
        return redisTemplate.opsForZSet().rangeWithScores(keyName, start, end);
    }

    public Set<K> reverseRange(long start, long end) {
        return redisTemplate.opsForZSet().reverseRange(keyName, start, end);
    }

    public Set<ZSetOperations.TypedTuple<K>> reverseRangeWithScores(long start, long end) {
        return redisTemplate.opsForZSet().reverseRangeWithScores(keyName, start, end);
    }
}
