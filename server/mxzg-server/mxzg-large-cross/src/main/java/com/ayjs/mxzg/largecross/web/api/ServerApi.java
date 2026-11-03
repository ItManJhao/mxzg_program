package com.ayjs.mxzg.largecross.web.api;


import com.alibaba.fastjson.JSON;
import com.ayjs.mxzg.common.excel.ExcelLoader;
import com.ayjs.mxzg.largecross.web.constant.WebErrorCode;
import com.ayjs.mxzg.largecross.web.support.WebResult;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.core.Logger;
import org.apache.logging.log4j.core.LoggerContext;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collection;
import java.util.Objects;

/**
 * @Author: CWJ
 * @Date: 2019/11/3
 **/
@RestController
@RequestMapping("/server")
@Slf4j
public class ServerApi {

    @Value("${config.path}")
    private String configPath;

    /**
     * 重新加载配置
     *
     * @param configs
     * @return
     */
    @RequestMapping(value = "/reloadConfig", method = RequestMethod.GET)
    public String reloadConfig(@RequestParam(name = "configs", required = false) String configs) {
        log.info("跨服收到刷新配置的指令");
        try {

            if (StringUtils.isBlank(configPath)) {
                return JSON.toJSONString(WebResult.of(WebErrorCode.FAIL.getCode(), "configPath is null"));
            }
            if (configs != null && !"".equals(configs)) {
                String[] configNames = configs.split(",");
                boolean success = ExcelLoader.loadSome(configPath, configNames);
                if (!success) {
                    return JSON.toJSONString(WebResult.of(WebErrorCode.FAIL.getCode(), ""));
                } else {
                    return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
                }
            } else {
                //刷新所有配置
                ExcelLoader.load(configPath);
                return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
            }
        } catch (Exception e) {
            e.printStackTrace();
            return JSON.toJSONString(WebResult.of(WebErrorCode.EXCEPTION.getCode(), e.getMessage()));
        }
    }

    /**
     * 日志等级接口
     *
     * @param level
     * @return
     */
    @RequestMapping(value = "/logLevel", method = RequestMethod.GET)
    public String logLevel(@RequestParam(name = "level", required = false) String level) {
        Level newLevel = Level.valueOf(level);
        if (Objects.isNull(newLevel)) {
            return JSON.toJSONString(WebResult.of(WebErrorCode.FAIL.getCode(), "level is error [" + level + "]"));
        }
        Collection<Logger> current = LoggerContext.getContext(false).getLoggers();
        Collection<org.apache.logging.log4j.core.Logger> notcurrent = LoggerContext.getContext().getLoggers();
        Collection<org.apache.logging.log4j.core.Logger> allConfig = current;
        allConfig.addAll(notcurrent);
        for (org.apache.logging.log4j.core.Logger log : allConfig) {
            log.setLevel(newLevel);
        }
        return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
    }

    @RequestMapping(value = "/gc", method = RequestMethod.GET)
    public String gc(@RequestParam(name = "args", required = true) String args) {
        if ("yes".equals(args)) {
            System.gc();
            log.info("gc end.");
        }
        return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
    }

    @RequestMapping(value = "/execute", method = RequestMethod.GET)
    public String execute(@RequestParam(name = "args", required = false) String args) {
        // 调试代码
        log.debug("gm execute ");


        return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
    }
}
