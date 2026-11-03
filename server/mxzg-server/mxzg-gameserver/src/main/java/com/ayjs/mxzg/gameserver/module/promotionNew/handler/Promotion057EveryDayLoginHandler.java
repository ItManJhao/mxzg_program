package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion057EveryDayLogin;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion057EveryDayLoginService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion057EveryDayLoginConfig;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion057GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.List;

/**
 * 每日登陆活动
 *
 * @author hyx
 */
@Controller
public class Promotion057EveryDayLoginHandler extends ProtocolHandler {

    @Autowired
    private Promotion057EveryDayLoginService promotion057EveryDayLoginService;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private ThingService thingService;

    /**
     * 每日登陆数据
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13200)
    public void everyDayLoginInfo(PlayerContext playerContext, Promotion057GMsg.GReqEveryDayLoginPromotion msg) {

        Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.MEI_RI_DENG_LU), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), "活动已结束");

        Promotion057EveryDayLogin promotion057EveryDayLogin = promotion057EveryDayLoginService.getOrRefresh(playerContext.getId());

        Promotion057GMsg.GResEveryDayLoginPromotion.Builder builder = Promotion057GMsg.GResEveryDayLoginPromotion.newBuilder();
        builder.setDayTurns(promotion057EveryDayLoginService.getDayTurns());
        builder.addAllIdx(promotion057EveryDayLogin.getTaskReward());

        promotion057EveryDayLogin.getTaskList().forEach((key, value) -> {
            ObjectGMsg.PSMapData.Builder data = promotion057EveryDayLoginService.builderTask(key, value);
            builder.addTaskList(data);
        });

        playerContext.write(CmdCode._13200, builder.build());
    }

    /**
     * 领取每日登陆奖励
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13201)
    public void getEveryDayLoginReward(PlayerContext playerContext, Promotion057GMsg.GReqEveryDayLoginReward msg) {

        Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.MEI_RI_DENG_LU), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), "活动已结束");

        Promotion057EveryDayLogin promotion057EveryDayLogin = promotion057EveryDayLoginService.getOrRefresh(playerContext.getId());

        Asserts.isTrue(!promotion057EveryDayLogin.getTaskReward().contains(msg.getIdx()), ErrorCode.PROMOTION_ID_HAD_REWARD.getValue(), "奖励已领取");

        Promotion057EveryDayLoginConfig config = promotion057EveryDayLoginService.getConfig(msg.getIdx());

        Asserts.isTrue(promotion057EveryDayLogin.getTaskList().get(config.getIdx()) >= config.getTargetStruct().getTarget(),
                ErrorCode.PROMOTION_NOT_PROGRESS.getValue(), "每日任务进度不足");

        promotion057EveryDayLogin.getTaskReward().add(msg.getIdx());
        promotion057EveryDayLoginService.updatePromotion(promotion057EveryDayLogin);

        thingService.add(playerContext.getId(), ImmutableThingUtil.fromJson(config.getReward()), GameEvent.EVERY_DAY_LOGIN_REWARD);

        Promotion057GMsg.GResEveryDayLoginReward.Builder builder = Promotion057GMsg.GResEveryDayLoginReward.newBuilder();
        builder.addAllIdx(promotion057EveryDayLogin.getTaskReward());
        playerContext.write(CmdCode._13201, builder.build());

    }

}
