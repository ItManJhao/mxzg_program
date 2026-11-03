package com.ayjs.mxzg.center.web.api;

import com.ayjs.mxzg.center.module.rechargeLimit.domain.CenterRechargeLimit;
import com.ayjs.mxzg.center.module.rechargeLimit.event.CenterRechargeLimitChargeEvent;
import com.ayjs.mxzg.center.module.rechargeLimit.service.CenterRechargeLimitService;
import com.ayjs.mxzg.center.web.constant.CenterRechargeLimitInfo;
import com.ayjs.mxzg.center.web.constant.WebErrorCode;
import com.ayjs.mxzg.center.web.support.WebResult;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.GJsonUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashSet;

/**
 * 充值回调接口
 */
@Slf4j
@RestController
@RequestMapping("/centerRecharge")
public class CenterRechargeApi {

    @Autowired
    private CenterRechargeLimitService centerRechargeLimitService;
    @Autowired
    private EventBus eventBus;

    /**
     * 充值限制条件
     * /centerRecharge/rechargeLimit
     *
     * @param data {"totalRecharge":100,"areas":["广东省","北京市"],"loginAreas":["广东省","北京市"]}
     * @return
     */
    @RequestMapping(value = "/rechargeLimit", method = {RequestMethod.GET, RequestMethod.POST})
    public String rechargeLimit(@RequestParam(name = "data") String data) {
        if (StringUtils.isBlank(data)) {
            return GJsonUtils.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), "data is null"));
        }
        try {
            CenterRechargeLimitInfo centerRechargeLimitInfo = GJsonUtils.fromJson(data, CenterRechargeLimitInfo.class);

            CenterRechargeLimit rechargeLimit = centerRechargeLimitService.get();
            rechargeLimit.setTotalRecharge(centerRechargeLimitInfo.getTotalRecharge());
            if (CollectionUtils.isEmpty(centerRechargeLimitInfo.getAreas())) {
                rechargeLimit.setAreas(new HashSet<>());
            } else {
                rechargeLimit.setAreas(centerRechargeLimitInfo.getAreas());
            }
            if (CollectionUtils.isEmpty(centerRechargeLimitInfo.getLoginAreas())) {
                rechargeLimit.setLoginAreas(new HashSet<>());
            } else {
                rechargeLimit.setLoginAreas(centerRechargeLimitInfo.getLoginAreas());
            }
            centerRechargeLimitService.updateRechargeLimit(rechargeLimit);

            eventBus.post(CenterRechargeLimitChargeEvent.of(centerRechargeLimitInfo.getTotalRecharge(),
                    rechargeLimit.getAreas(), rechargeLimit.getLoginAreas()));
            log.debug("rechargeLimitInfo:{}", GJsonUtils.toJson(rechargeLimit));
        } catch (Exception e) {
            log.error("/centerRecharge/rechargeLimit data:{}", data, e);
            return GJsonUtils.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), "设置失败！异常"));
        }
        return GJsonUtils.toJson(WebResult.of(WebErrorCode.SUCCESS.getCode(), "SUCCESS"));
    }
}
