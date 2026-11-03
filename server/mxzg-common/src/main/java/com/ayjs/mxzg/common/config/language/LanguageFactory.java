package com.ayjs.mxzg.common.config.language;

import java.util.HashMap;
import java.util.Map;


public class LanguageFactory {

    private static final LanguageFactory instance = new LanguageFactory();

    private final Map<Integer, ILanguageCache> cacheMap = new HashMap<>();

    private LanguageFactory() {
    }

    public static LanguageFactory getInstance() {
        return instance;
    }

    public void register(Integer lang, ILanguageCache languageCache) {
        cacheMap.put(lang, languageCache);
    }

    public Map<Integer, ILanguageBean> getLanguageMap(Integer lang) {
        ILanguageCache cache;
        return (cache = cacheMap.get(lang)) == null ? null : cache.getLanguageMap();
    }

    private ILanguageBean getLanguage(Integer lang, int key) {
        ILanguageCache cache;
        return (cache = cacheMap.get(lang)) == null ? null : cache.getLanguage(key);
    }

    public String getValue(Integer lang, int key) {
        ILanguageBean result = getLanguage(lang, key);
        return result == null ? "" : result.getValue();
    }
}
