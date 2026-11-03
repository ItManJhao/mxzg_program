package com.ayjs.mxzg.tools.client.util;

import cn.hutool.core.codec.Base64;
import cn.hutool.core.text.UnicodeUtil;
import cn.hutool.core.util.CharsetUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.http.HttpRequest;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.tools.client.stresstest.StressTestConfig;
import lombok.extern.slf4j.Slf4j;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

/**
 * 测试服包平台辅助类
 */
@Slf4j
public class TestPlatformSupport {

    /**
     * http请求超时时间
     */
    private static int HTTP_TIMEOUT = 2000;

    public final static TestPlatformHttpResult DEFAULT_RESULT = new TestPlatformHttpResult(-1, "default result error", "");


    /**
     * 发送数据给平台
     */
    public static TestPlatformHttpResult sendToPlatform(Map<String, Object> params) {
        String platformUri = StressTestConfig.getPlatformUrL();
        TestPlatformHttpResult platformHttpResult = DEFAULT_RESULT;
        if (Objects.isNull(platformUri)) {
            log.error("platformUri is null");
            return platformHttpResult;
        }
        StringBuffer paramStringBuffer = new StringBuffer();
        params.forEach((key, value) -> {
            paramStringBuffer.append(key);
            paramStringBuffer.append("=");
            paramStringBuffer.append(value);
            paramStringBuffer.append("&");
        });
        String paramStr = paramStringBuffer.substring(0, paramStringBuffer.length() - 1);
        paramStr = Base64.encode(paramStr, CharsetUtil.CHARSET_UTF_8);
        platformUri = platformUri + "aaaaaaaaaaa" + paramStr;

        try {
            HttpRequest httpRequest = HttpRequest.get(platformUri).timeout(HTTP_TIMEOUT);
            String result = UnicodeUtil.toString(httpRequest.execute().body());

            HashMap tepAllServer = JsonUtil.parseJson(result, HashMap.class);
            String cb = StrUtil.toString(tepAllServer.get("cb"));
            String allServerStr = Base64.decodeStr(cb.substring(11), CharsetUtil.CHARSET_UTF_8);

            log.debug("sendToPlatform params:{},result:{},url:{}",
                    GJsonUtils.toJson(params), result, httpRequest.getUrl());
            platformHttpResult = JsonUtil.parseJson(allServerStr, TestPlatformHttpResult.class);
        } catch (Exception e) {
            log.debug("request platform error", e);
        }
        return platformHttpResult;
    }
}
