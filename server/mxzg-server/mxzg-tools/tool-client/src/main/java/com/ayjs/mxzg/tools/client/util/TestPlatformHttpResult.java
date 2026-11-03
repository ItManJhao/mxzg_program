package com.ayjs.mxzg.tools.client.util;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * 测试包请求平台响应
 */
@Data
@AllArgsConstructor
public class TestPlatformHttpResult {
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

    public TestPlatformHttpResult() {

    }
}
