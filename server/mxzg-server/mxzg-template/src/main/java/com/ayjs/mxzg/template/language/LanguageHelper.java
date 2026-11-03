package com.ayjs.mxzg.template.language;

import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.struct.Language;
import com.ayjs.mxzg.config.struct.LanguageConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class LanguageHelper {

    //#服务器的语言版本 1:cn 简体中文  2:hk 香港 3:tw 繁体中文 4:en 英文 5:jp 日文 6:kor韩文 7 vn越南
    @Value("${server.lang:1}")
    private int serverLang;
    @Autowired
    private LanguageSysCache languageSysCache;


    /**
     * 根据key获取默认的语言配置
     *
     * @param cLanguage
     * @return
     */
    public String getLanguageBy(LanguageConfig cLanguage) {
        Language language = Language.valueOf(serverLang);
        return language.getLanguage(cLanguage);
    }

    /**
     * 根据key和语言值获取语言
     *
     * @param cLanguage
     * @param languageCode
     * @return
     */
    public String getLanguageBy(LanguageConfig cLanguage, int languageCode) {
        if (languageCode <= 0) {
            languageCode = serverLang;
        }
        Language language = Language.valueOf(languageCode);
        return language.getLanguage(cLanguage);
    }

//    public String getLanguage(int langId) {
//        return getLanguageBy(languageSysCache.getOrThrow(langId));
//    }

    public String getLanguage(String key) {
        return getLanguageBy(languageSysCache.getByKey(key));
    }

}
