package com.ayjs.mxzg.common.persistence.repository;


import com.ayjs.mxzg.common.executor.WrappedRunnable;
import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.CRepository;
import com.ayjs.mxzg.common.util.ConcurrentHashSet;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Objects;
import java.util.concurrent.TimeUnit;

/**
 *
 */
public class DelayedJDBCRepository<T extends AbstractEntity> extends CachedJDBCRepository<T> {

    private static final Log log = LogFactory.getLog(DelayedJDBCRepository.class);

    private int batchSize = 200;

    private int interval = 10;

    private int delay = 60;

    protected final ConcurrentHashSet<T> list = new ConcurrentHashSet<>();

    private class DelayTask extends WrappedRunnable {

        public void execute() {
            delaySave(false);
        }

        @Override
        public String toString() {
            return DelayedJDBCRepository.this.getClass().toString() + "$" + this.getClass().getSimpleName();
        }
    }

    protected DelayedJDBCRepository() {
        CRepository repository = getAnnotation();
        this.batchSize = repository.batch();
        this.interval = repository.interval();
        this.delay = repository.delay();
        this.pool.scheduleWithFixedDelay(new DelayTask(),
                interval,
                interval,
                TimeUnit.SECONDS);
        DataBaseAccessorManager.getInstance().addHook(() -> delaySave(true));
    }

    @Override
    public void update(T entity) {
        entity.setLastModifiedTimestamp();
        list.add(entity);
    }

    @Override
    public void update(List<T> entities) {
        entities.forEach(n -> {
            n.setLastModifiedTimestamp();
            list.add(n);
        });
    }

    public synchronized void shutdown() {
        delaySave(true);
    }

    public synchronized void delaySave(boolean force) {
        List<T> save = null;
        List<T> errorArray = null;
        Iterator<T> it = list.iterator();
        while (it.hasNext()) {
            T entity = it.next();
            if (entity.isNeedSave(delay * 1000, force)) {
                it.remove();
                if (Objects.isNull(save)){
                    save = new ArrayList<>();
                }
                save.add(entity);
            }
            if (Objects.nonNull(save) && save.size() >= batchSize) {
                try {
                    super.update(save);
                } catch (Exception e) {
                    log.error("delay save failed", e);
                    if (Objects.isNull(errorArray)) {
                        errorArray = new ArrayList<>();
                    }
                    errorArray.addAll(save);
                } finally {
                    save = new ArrayList<>();
                }
            }
        }
        if (Objects.nonNull(save) && save.size() > 0) {
            try {
                super.update(save);
            } catch (Exception e) {
                log.error("delay save failed", e);
                if (Objects.isNull(errorArray)) {
                    errorArray = new ArrayList<>();
                }
                errorArray.addAll(save);
            }
        }
        try {
            if (errorArray != null && !errorArray.isEmpty()) {
                list.addAll(errorArray);
            }
        } catch (Exception e) {
            log.error("delay save failed add error array", e);
        }
    }
}
