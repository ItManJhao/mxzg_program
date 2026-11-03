package com.ayjs.mxzg.gameserver.web.timer;

import cn.hutool.http.HttpUtil;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.web.support.WebResult;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * @Author: CWJ
 * @Date: 2020/6/15
 **/
@Slf4j
@Controller
public class ServerHeartTimer extends AbstractCronTask {

    @Autowired
    private ServerConfig serverConfig;

    private static String HEART_BEAT_URI = "/cli/ServerHeartBeat/record?sid=";

    @Override
    public Object identity() {
        return "server heart";
    }

    @Override
    public String expression() {
        return "0 0/1 * * * ?";
    }

    @Override
    public void run() {
        String managementUrl = null;
        try {
            managementUrl = serverConfig.getManagementUrl();
            if (managementUrl.length() < 6) {
                log.info("serverConfig.getPlatformHeartUrl() {} is error :", managementUrl);
                return;
            }
            managementUrl = managementUrl + HEART_BEAT_URI + serverConfig.getServerId();
            String result = HttpUtil.get(managementUrl, 3000);
            WebResult webResult = JsonUtil.parseJson(result, WebResult.class);
            if (webResult.getCode() == 0) {
                log.error("请求心跳失败 managementUrl:{}", managementUrl);
            }
        } catch (Exception e) {
            log.info("发送心跳到后台,url:" + managementUrl, e);
        }
    }
}
