package com.ayjs.mxzg.common.persistence.repository;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.CRepository;
import com.ayjs.mxzg.common.persistence.hook.HookHandler;
import com.ayjs.mxzg.common.persistence.hook.HookOpportunity;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * Notice:
 * <p>
 * 1. 所有继承了{@code DelayedJDBCRepository}的仓储在{@code @Index} 构建时,
 * 如果是唯一索引, 那么被索引的内容不应该被修改, 否则可能会出现唯一索引冲突的情况。
 * 这是因为 {@code add}, {@code remove} 是即时更新到数据库中, 而 {@code save} 是延迟更新到数据库中。
 * 2. 唯一索引如果存在, 应当只能存在一个
 *
 * 默认缓存存活时间24小时3分20秒
 *
 * @author tangyangbo created at 2018/3/1 上午10:06
 */
@CRepository(source = "data", timeToLive = 86600)
public abstract class BaseRepository<T extends AbstractEntity> extends DelayedJDBCRepository<T> {
    //
    @Autowired
    private HookHandler<T> hookHandler;

    @Override
    public void add(T entity) {
        super.add(entity);
    }

    @Override
    public void add(List<T> entities) {
        super.add(entities);
    }

    @Override
    public T get(Object id) {
        T entity = super.get(id);
        if (entity != null) {
            if (hookHandler.hookIt(entity, HookOpportunity.GET_AFTER)) {
                update(entity);
            }
        }
        return entity;
    }



    @Override
    public List<T> list(Map<String, Object> options) {
        if (options == null || options.isEmpty()) {
            return Collections.emptyList();
        }
        List<T> list = super.list(options);
        list.forEach(entity -> {
            if (hookHandler.hookIt(entity, HookOpportunity.GET_AFTER)) {
                update(entity);
            }
        });
        return list;
    }

    @Override
    public List<T> listAll() {
        List<T> list = super.listAll();
        list.forEach(entity -> {
            if (hookHandler.hookIt(entity, HookOpportunity.GET_AFTER)) {
                update(entity);
            }
        });
        return list;
    }
}
