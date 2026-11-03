package com.ayjs.mxzg.gameserver.module.global.platform;

import java.util.Map;
import java.util.Objects;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.web.support.PlatformHttpResult;
import com.ayjs.mxzg.template.constant.GameConstant;
import com.google.common.reflect.TypeToken;

import cn.hutool.core.text.UnicodeUtil;
import cn.hutool.http.HttpRequest;
import lombok.extern.slf4j.Slf4j;

/**
 * 平台辅助类
 */
@Slf4j
@Component
public class PlatformSupport {

    @Autowired
    private ServerConfig serverConfig;

    public final static PlatformHttpResult DEFAULT_RESULT = new PlatformHttpResult(-1, "default result error", "");

    /**
     * 发送数据给平台
     */
    public PlatformHttpResult sendToPlatform(Map<String, Object> params) {
        String platformUri = serverConfig.getPlatformUri();
        PlatformHttpResult platformHttpResult = DEFAULT_RESULT;
        if (Objects.isNull(platformUri)) {
            log.error("platformUri is null");
            return platformHttpResult;
        }
        try {
            long startTime = System.currentTimeMillis();
            HttpRequest httpRequest = HttpRequest.get(platformUri).form(params).timeout(GameConstant.HTTP_TIMEOUT);

            String result = UnicodeUtil.toString(httpRequest.execute().body());
            long endTime = System.currentTimeMillis();
            log.debug("http execute time:{} sendToPlatform params:{},result:{},url:{}", (endTime - startTime),
                    GJsonUtils.toJson(params), result, httpRequest.getUrl());
            platformHttpResult = JsonUtil.parseJson(result, PlatformHttpResult.class);
        } catch (Exception e) {
            log.debug("request platform error", e);
        }
        return platformHttpResult;
    }

    /**
     * 请求平台返回指定类型数据
     */
    public <T> T callPlatform(Map<String, Object> params, Class<T> clazz) {
        T result = null;
        try {
            PlatformHttpResult httpResult = sendToPlatform(params);
            if (Objects.nonNull(httpResult) && httpResult.success()) {
                result = GsonUtils.fromJson(httpResult.getData(), clazz);
            }
        } catch (Exception e) {
            log.debug("call platform error", e);
        }
        return result;
    }

    /**
     * 请求平台返回指定类型数据
     */
    public <T> T callPlatform(Map<String, Object> params, TypeToken<T> type) {
        T result = null;
        try {
            PlatformHttpResult httpResult = sendToPlatform(params);
            if (Objects.nonNull(httpResult) && httpResult.success()) {
                result = GsonUtils.fromJson(httpResult.getData(), type);
            }
        } catch (Exception e) {
            log.debug("call platform error", e);
        }

        return result;
    }
}
