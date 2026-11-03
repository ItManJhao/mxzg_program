package com.ayjs.mxzg.common.config.language;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SensitiveFactory {

    private static final SensitiveFactory instance = new SensitiveFactory();

    private final Map<Integer, ISensitiveCache<? extends ILanguageBean>> cacheMap = new HashMap<>();

    private SensitiveFactory() {
    }

    public static SensitiveFactory getInstance() {
        return instance;
    }

    public <T extends ILanguageBean> void register(Integer lang, ISensitiveCache<T> languageCache) {
        cacheMap.put(lang, languageCache);
    }

    @SuppressWarnings("unchecked")
    public <T extends ILanguageBean> List<T> getLanguageList(Integer lang) {
        ISensitiveCache<T> cache;
        return (cache = (ISensitiveCache<T>) cacheMap.get(lang)) == null ? null : cache.getSensitiveList();
    }
}
