package com.ayjs.mxzg.common.config;

import java.util.List;

/**
 *
 */
public interface ConfigLoader {

    /**
     * 加载配置文件
     */
    void load();

    /**
     * 重新加载指定配置文件
     *
     * @param filenameList 文件名(有扩展名)列表
     */
    void reload(List<String> filenameList);
}
