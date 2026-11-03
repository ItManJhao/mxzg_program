package com.ayjs.mxzg.common.config.reader;

import java.io.File;

/**
 * Reader
 */
public interface IReader {

    /**
     * 处理数据
     *
     * @param file
     * @return
     */
    FileMeta handlerData(File file);

    /**
     * 是否匹配类型
     *
     * @param name
     * @return
     */
    boolean matchType(String name);
}
