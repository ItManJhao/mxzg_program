package com.ayjs.mxzg.common.cache;

import com.ayjs.mxzg.common.executor.WrappedRunnable;
import com.ayjs.mxzg.common.util.ConcurrentHashSet;
import com.ayjs.mxzg.common.util.NamesThreadFactory;

import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * 缓存管理器
 */
public class CacheManager {

    static class CacheManagerHolder {
        static CacheManager instance = new CacheManager();
    }
    /**
     * 获取缓存管理器的单例
     *
     * @return 缓存管理器
     */
    public static CacheManager getInstance() {
        return CacheManagerHolder.instance;
    }

    private final class RemoveExpiredElementTask extends WrappedRunnable implements Runnable {

        public void execute() {
            caches.forEach(ICache::removeAllExpired);
        }
    }

    /*
     * 清理过期缓存的定时器
     */
    private final ScheduledExecutorService cleaner;

    /*
     * 所有的缓存
     */
    private final ConcurrentHashSet<ICache> caches;

    private CacheManager() {
        this.caches = new ConcurrentHashSet<>();
        this.cleaner = new ScheduledThreadPoolExecutor(1, new NamesThreadFactory("cache-cleaner"));
        this.cleaner.scheduleWithFixedDelay(new RemoveExpiredElementTask(),
                60,
                60,
                TimeUnit.SECONDS);
    }

    /**
     * 将一个缓存加入管理
     *
     * @param cache 待加入的缓存
     */
    public void addCache(ICache cache) {
        caches.add(cache);
    }

    /**
     * 移除一个缓存
     *
     * @param cache 待移除的缓存
     */
    public void removeCache(ICache cache) {
        caches.remove(cache);
    }

    /**
     * 移除所有缓存
     */
    public void removeAllCaches() {
        caches.clear();
    }
}
