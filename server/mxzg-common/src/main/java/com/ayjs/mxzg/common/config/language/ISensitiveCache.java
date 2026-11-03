package com.ayjs.mxzg.common.config.language;

import java.util.List;

public interface ISensitiveCache<T extends ILanguageBean> {

    List<T> getSensitiveList();
}
