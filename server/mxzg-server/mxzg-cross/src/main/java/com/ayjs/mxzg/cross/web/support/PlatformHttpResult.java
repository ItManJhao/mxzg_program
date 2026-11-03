package com.ayjs.mxzg.cross.web.support;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * 请求平台响应
 */
@Data
@AllArgsConstructor
public class PlatformHttpResult {
    /**
     * 结果码，200正常
     */
    private int code;
    /**
     * 消息
     */
    private String msg;
    /**
     * 响应数据
     */
    private String data;

    public boolean success() {
        return code == 200;
    }

    public PlatformHttpResult() {

    }
}
