package com.ayjs.mxzg.common.config.reader;

import lombok.Data;

import java.util.List;

/**
 * 读取的文件元数据
 */
@Data
public class FileMeta {
    /**
     * 文件名
     */
    private String name;
    /**
     * 文件字段定义头
     */
    private String[] head;
    /**
     * 文件数据
     */
    private List<String[]> data;
    /**
     * 读取类型
     */
    private String[] readType;
}
