package com.ayjs.mxzg.largecross.web.api;

import com.alibaba.fastjson.JSON;
import com.ayjs.mxzg.largecross.servergroup.service.ServerGroupService;
import com.ayjs.mxzg.largecross.web.constant.WebErrorCode;
import com.ayjs.mxzg.largecross.web.support.WebResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

/**
 * @Author: CWJ
 * @Date: 2020/6/20
 **/
@RestController
@RequestMapping("/serverGroup")
@Slf4j
public class ServerGroupApi {

    @Autowired
    private ServerGroupService serverGroupService;

    /**
     * 重新分组
     *
     * @return
     */
    @RequestMapping(value = "/regroup", method = RequestMethod.GET)
    public String regroup() {
        log.info("大跨服服收到跨服重组指令");
        try {
            serverGroupService.startRegroup();
        } catch (Exception e) {
            e.printStackTrace();
            return JSON.toJSONString(WebResult.of(WebErrorCode.EXCEPTION.getCode(), e.getMessage()));
        }
        return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), "跨服重新分组成功"));
    }
}
