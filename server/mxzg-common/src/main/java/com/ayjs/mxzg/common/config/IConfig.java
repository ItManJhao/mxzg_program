package com.ayjs.mxzg.common.config;

import java.util.List;

public interface IConfig<T> {

    /**
     * 配置文件的文件名
     *
     * @return
     */
    String getFilename();

    /**
     * 排序方法数组
     *
     * @return
     */
    default String[] getSorts() {
        return null;
    }

    /**
     * 加载数据在缓存中
     *
     * @param configDataList
     */
    void loadCache(String[] configHead, List<String[]> configDataList, String[] readType);

    /**
     * 配置数据类
     *
     * @return
     */
    Class<T> getConfigClass();

    /**
     * 配置数据列表
     *
     * @return
     */
    List<T> getConfigList();
}
