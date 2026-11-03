package com.ayjs.mxzg.common.config.language;

import java.util.Map;

public interface ILanguageCache {

    ILanguageBean getLanguage(int key);

    Map<Integer, ILanguageBean> getLanguageMap();
}
