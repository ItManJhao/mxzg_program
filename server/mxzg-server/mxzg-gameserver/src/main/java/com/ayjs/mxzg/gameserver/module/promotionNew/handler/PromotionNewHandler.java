/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeConstants;
import com.ayjs.mxzg.config.excel.cache.PromotionControlSysCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionControl;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.BasePromotionService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.protocol.PromotionNewGMsg;
import com.ayjs.mxzg.protocol.PromotionNewGMsg.GReqRunningPromotion;
import com.ayjs.mxzg.protocol.PromotionNewGMsg.GResRunningPromotion;
import com.ayjs.mxzg.protocol.PromotionNewGMsg.PbPromotionData;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.Objects;

/**
 * @author YY
 *
 */
@Controller
@Slf4j
public class PromotionNewHandler extends ProtocolHandler {

    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private ServerParamService serverParamService;
    @Autowired
    private PromotionControlSysCache promotionControlSysCache;

    /**
     * 获取所有进行中的活动
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._20101)
    public void getAllRunningPromotion(PlayerContext playerContext, GReqRunningPromotion msg) {

        List<PromotionControl> list = promotionControlService.getAllWillRun();

        GResRunningPromotion.Builder builder = GResRunningPromotion.newBuilder();
        int openBreak = DateTimeUtil.theDayBreak(serverParamService.getServerStartTime());

        for (PromotionControl control : list) {
            builder.addPromotions(getBuilder(openBreak, control));
        }

        playerContext.write(CmdCode._20101, builder.build());
    }

    private boolean getPromotionIdx(List<Integer> idxList) {
        if (idxList == null) {
            return false;
        }
        if (idxList.size() == 1 && idxList.get(0) <= 0) {
            return false;
        }
        return true;
    }

    @CMD(id = CmdCode._20102)
    public void activityConfig(PlayerContext playerContext, PromotionNewGMsg.GReqActivityConfig req) {
        PromotionNewGMsg.GResActivityConfig.Builder builder = PromotionNewGMsg.GResActivityConfig.newBuilder();

        builder.setIsHotfix(req.getIsHotfix());

        List<PromotionControl> list = null;
        if (getPromotionIdx(req.getIdsList())) {
            list = promotionControlService.selectPromotionList(req.getIdsList());
        } else {
            list = promotionControlService.getAllPromotion();

        }

        for (PromotionControl control : list) {
            try {
                PromotionType type = PromotionType.valueOf(control.getType());
                if (type == null) {
                    log.error("运营活动{}没有找到枚举定义!", control.getType());
                    continue;
                }
                if (type.getOpenType() == 2) {
                    BasePromotionService<?> basePromotionService = BasePromotionService.getPromotionService(type);
                    if (basePromotionService == null) {
                        log.error("活动{}{}无法找到服务类", type.getId(), type.getName());
                        continue;
                    }
                    String configStr = basePromotionService.getConfigStr();
                    if (configStr != null) {
                        PromotionNewGMsg.PbServerActivityConfig.Builder ele = PromotionNewGMsg.PbServerActivityConfig.newBuilder();
                        ele.setId(type.getId());
                        ele.setConfig(configStr);
                        builder.addConfigs(ele);
                    } else {
                        log.error("运营活动{}开了,但是没有配置发送给客户端!", type);
                    }

                }
            } catch (Exception e) {
                log.error(String.format("活动解析配置推送失败!活动类型{%s}", control.getType()), e);
            }
        }
        playerContext.write(CmdCode._20102, builder.build());
    }

    @CMD(id = CmdCode._20104)
    public void updatePromotionInfo(PlayerContext playerContext, PromotionNewGMsg.GReqActivityBaseInfoUpdate msg) {
        PromotionNewGMsg.GResActivityBaseInfoUpdate.Builder builder = PromotionNewGMsg.GResActivityBaseInfoUpdate.newBuilder();

        List<PromotionControl> promotionControlList = promotionControlService.selectPromotionList(msg.getIdsList());
        int openBreak = DateTimeUtil.theDayBreak(serverParamService.getServerStartTime());

        promotionControlList.forEach(promotionControl -> {
            builder.addPromotions(getBuilder(openBreak, promotionControl));
        });

        playerContext.write(CmdCode._20104, builder.build());
    }

    private PbPromotionData.Builder getBuilder(int openBreak, PromotionControl control) {
        PbPromotionData.Builder ele = PbPromotionData.newBuilder();
        ele.setId(control.getType());
        ele.setStartTime(Math.max(openBreak + TimeConstants.ONE_DAY_SECOND * (control.getLimitDays() - 1), control.getStartTime()));
        CPromotionControl promotionControl = promotionControlSysCache.getById(control.getType());
        boolean isCycle = false;
        if (Objects.nonNull(promotionControl)) {
            isCycle = promotionControl.getInterval_time() > 0;
        }
        if (isCycle) {
            // 循环活动是按天算的，所以最后一天减去一秒，给客户端好显示
            ele.setEndTime(control.getEndTime() - 1);
            ele.setClearTime(control.getClearTime() - 1);
        } else {
            ele.setEndTime(control.getEndTime());
            ele.setClearTime(control.getClearTime());
        }
        ele.setTurns(control.getTurns());
        return ele;
    }

}
