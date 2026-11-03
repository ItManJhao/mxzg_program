package com.ayjs.mxzg.common.persistence.log;

import com.ayjs.mxzg.common.base.Initialization;
import com.ayjs.mxzg.common.persistence.annotation.CRepository;
import com.ayjs.mxzg.common.persistence.generator.IdGenerator;
import com.ayjs.mxzg.common.persistence.generator.IdGeneratorRegistry;
import com.ayjs.mxzg.common.persistence.generator.LongIdGenerator;
import com.ayjs.mxzg.common.persistence.persister.Persister;
import com.ayjs.mxzg.common.persistence.persister.PersisterRegistry;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.TypeUtil;
import com.google.common.base.Throwables;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.Assert;

import java.util.List;
import java.util.Map;

/**
 * 日志仓储操作
 */
@CRepository(source = "log")// 对应DataBaseType.Log.getType()
public abstract class BaseLogRepository<T extends AbstractLog> implements IRepository<T>, Initialization {

    @Autowired
    private IdGeneratorRegistry idGeneratorRegistry;
    @Autowired
    private PersisterRegistry<Long, T> persisterRegistry;

    /**
     * 实体类型
     */
    protected final Class<T> entityType;
    /**
     * 持久化
     */
    protected Persister<Long, T> persister;

    @SuppressWarnings("unchecked")
    public BaseLogRepository() {
        this.entityType = (Class<T>) TypeUtil.resolveClassArguments(getClass(), IRepository.class)[0];
    }

    @Override
    public void initialize() {
        this.persister = persisterRegistry.getPersister(entityType);
    }

    public Class<T> getEntityType() {
        return entityType;
    }

    private Long nextId() {
        IdGenerator idGenerator = idGeneratorRegistry.getIdGenerator(entityType);
        Assert.notNull(idGenerator, () -> String.format("{%s} IdGenerator不存在", entityType.getName()));
        Assert.isTrue(idGenerator instanceof LongIdGenerator, () -> String.format("{%s} IdGenerator类型不对", entityType.getName()));
        return ((LongIdGenerator) idGenerator).nextId();
    }

    public T create() {
        try {
            T entity = entityType.newInstance();
            entity.setId(nextId());
            return entity;
        } catch (Exception e) {
            Throwables.throwIfUnchecked(e);
            throw new RuntimeException(e);
        }
    }

    @Override
    public void add(T entity) {
        persister.add(entity);
    }

    @Override
    public void add(List<T> entities) {
        persister.add(entities);
    }

    @Override
    public void remove(T entity) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void remove(List<T> entities) {
        throw new UnsupportedOperationException();
    }

    @Override
    public T get(Object id) {
        throw new UnsupportedOperationException();
    }

    @Override
    public List<T> listAll() {
        throw new UnsupportedOperationException();
    }

    @Override
    public List<T> list(Map<String, Object> options) {
        throw new UnsupportedOperationException();
    }

    @Override
    public T get(String field, Object value) {
        throw new UnsupportedOperationException();
    }

    @Override
    public List<T> list(String field, Object value) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void update(T entity) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void update(List<T> entities) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void truncateAll() {
        throw new UnsupportedOperationException();
    }
}
