package com.ayjs.mxzg.center.web.api;


import com.alibaba.fastjson.JSON;
import com.ayjs.mxzg.center.module.CenterServerWorker;
import com.ayjs.mxzg.center.web.constant.WebErrorCode;
import com.ayjs.mxzg.center.web.support.WebResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

/**
 * 中心服操作
 */
@RestController
@RequestMapping("/centerServer")
@Slf4j
public class CenterServerApi {

    @Autowired
    private CenterServerWorker centerServerWorker;

    /**
     * 重新分组
     * @return
     */
    @RequestMapping(value = "/regroup", method = RequestMethod.GET)
    public String regroup() {
		log.info("中心服收到跨服重组指令");
		try {
			centerServerWorker.startRegroup();
		} catch (Exception e) {
			e.printStackTrace();
			return JSON.toJSONString(WebResult.of(WebErrorCode.EXCEPTION.getCode(), e.getMessage()));
		}
		return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), "跨服重新分组成功"));
    }
}
