package com.ayjs.mxzg.gameserver.web.api;

import com.alibaba.fastjson.JSON;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.web.activity.config.EmptyActivityConfig;
import com.ayjs.mxzg.gameserver.web.activity.config.IActivityConfig;
import com.ayjs.mxzg.gameserver.web.activity.struct.ActivityData;
import com.ayjs.mxzg.gameserver.web.constant.WebErrorCode;
import com.ayjs.mxzg.gameserver.web.event.PromotionChangeEvent;
import com.ayjs.mxzg.gameserver.web.exception.WebErrorCodeException;
import com.ayjs.mxzg.gameserver.web.support.WebResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;

/**
 *
 */
@RestController
@RequestMapping("/activity")
@Slf4j
public class ActivityApi {


    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private ServerParamService serverParamService;

    /**
     * 添加或修改活动
     *
     * @return
     */
    @RequestMapping(value = "/addOrUpdateActivity", method = RequestMethod.POST)
    public String addPayActivity(String data) {
        log.info("----activity string---------" + data);
        try {
            openActivity(data);
        } catch (WebErrorCodeException e) {
            log.error("活动开启失败！", e);
            return JsonUtil.toJson(WebResult.of(e.getErrorCode(), e.getMessage()));
        }

        return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), "成功"));
    }

    private void openActivity(String data) {
        ActivityData activityData = JsonUtil.parseJson(data, ActivityData.class);

        if (activityData.getCtime() < activityData.getEtime() || activityData.getCtime() < activityData.getStime()
                || activityData.getEtime() < activityData.getStime()) {
            throw new WebErrorCodeException(String.format("活动时间传输错误，开始时间:%s,结束时间:%s，清楚时间:%s", activityData.getStime(),
                    activityData.getEtime(), activityData.getCtime()), WebErrorCode.FAIL.getCode());
        }
        PromotionType type = PromotionType.valueOf(activityData.getType_id());
        if (type == null) {
            throw new WebErrorCodeException(String.format("活动类型错误，请检查活动id:%s", activityData.getType_id()), WebErrorCode.FAIL.getCode());
        }

        PromotionControl promotionControl = promotionControlService.getControl(type);
        if (promotionControlService.isPromotionRunning(type) && promotionControl.getStartTime() < activityData.getStime()) {
            throw new WebErrorCodeException(String.format("活动正在开启,不能将开启时间往后设置"), WebErrorCode.FAIL.getCode());
        }
        List<? extends IActivityConfig> list = JsonUtil.getList(activityData.getData(), type.getClz());
        List<? extends IActivityConfig> configList = list.stream().filter(config -> config.getPriority_status() == 1).collect(Collectors.toList());
        if (configList.isEmpty()) {
            int openDay = DateTimeUtil.apartDay(activityData.getStime(), serverParamService.getServerStartTime()) + 1;
            configList = list.stream().filter(config -> config.getStar_server_day() <= openDay && config.getEnd_server_day() >= openDay).collect(Collectors.toList());

            if (configList.isEmpty() && type.getClz() != EmptyActivityConfig.class) {
                throw new WebErrorCodeException(String.format("根据天服天数获取到的配置为空，不开启活动,idx:%s", activityData.getType_id()), WebErrorCode.FAIL.getCode());
            }
        }

        promotionControl.setClearTime(activityData.getCtime());
        promotionControl.setEndTime(activityData.getEtime());
        promotionControl.setStartTime(activityData.getStime());
        promotionControl.setNextTime(activityData.getStime());
        promotionControl.setLimitDays(activityData.getLimit_days());
        promotionControl.setConfig(JsonUtil.toJson(configList));
        promotionControl.replaceConfig(configList);

        promotionControlService.updateControl(promotionControl);

        eventBus.post(PromotionChangeEvent.of(type.getId()));
        log.info("修改活动{}数据成功{}", type, data);
    }
}
