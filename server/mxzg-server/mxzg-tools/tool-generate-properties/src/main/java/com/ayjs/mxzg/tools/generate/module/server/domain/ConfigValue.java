package com.ayjs.mxzg.tools.generate.module.server.domain;

import lombok.Value;

/**
 * 配置描述
 * key 和 desc 都是空时为空行
 * <p>
 * key为空，desc 不为空时，只有注释
 * #desc
 * key不为空，desc为空时，只有数据
 * kye=value
 * key不为空，desc不为空时，数据和注释都有
 * #desc
 * key=value
 */
@Value(staticConstructor = "of")
public class ConfigValue {
    /**
     * key
     */
    private String key;
    /**
     * 值
     */
    private Object value;
    /**
     * 描述
     */
    private String desc;


}
