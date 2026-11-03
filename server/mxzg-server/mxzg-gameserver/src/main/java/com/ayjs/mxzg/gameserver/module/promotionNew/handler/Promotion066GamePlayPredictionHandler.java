package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion066GamePlayPredictionSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion066GamePlayPrediction;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion066GamePlayPrediction;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion066GamePlayPredictionService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.promotion066GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * 新功能预告活动
 *
 * @author hyx
 */
@Controller
public class Promotion066GamePlayPredictionHandler extends ProtocolHandler {

    @Autowired
    private Promotion066GamePlayPredictionService promotion066GamePlayPredictionService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private Promotion066GamePlayPredictionSysCache promotion066GamePlayPredictionSysCache;
    @Autowired
    private RoleService roleService;

    @CMD(id = CmdCode._13260)
    public void newGamePlayInfo(PlayerContext playerContext, promotion066GMsg.GReqNewGamePlayInfo msg) {

        Promotion066GamePlayPrediction promotion066GamePlayPrediction = promotion066GamePlayPredictionService.getPromotionInfo(playerContext.getId());
        CPromotion066GamePlayPrediction config = promotion066GamePlayPredictionSysCache.getOrThrow(1);

        promotion066GMsg.GResNewGamePlayInfo.Builder builder = promotion066GMsg.GResNewGamePlayInfo.newBuilder();
        builder.setReceiveTime(promotion066GamePlayPrediction.getReceiveTime());
        builder.setStartTime(config.getStartTime());
        builder.setEndTime(config.getEndTime());
        playerContext.write(CmdCode._13260, builder.build());

    }

    @CMD(id = CmdCode._13261)
    public void getEveryReward(PlayerContext playerContext, promotion066GMsg.GReqGetEveryDayReward msg) {

        CPromotion066GamePlayPrediction config = promotion066GamePlayPredictionSysCache.getOrThrow(1);

        Asserts.isTrue(config.getStartTime() <= DateTimeUtil.currentSecond() && config.getEndTime() >= DateTimeUtil.currentSecond(),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("功能活动{%s}未在开启状态", PromotionType.GONG_NENG_YU_GAO));

        Promotion066GamePlayPrediction promotion066GamePlayPrediction = promotion066GamePlayPredictionService.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(promotion066GamePlayPrediction.getReceiveTime() < DateTimeUtil.dayBreak(),
                ErrorCode.PROMOTION_TOOK_REWARD.getValue(), "奖励已领取");

        Role role = roleService.getOrThrow(playerContext.getId());
        Asserts.isTrue(config.getOpen_level() <= role.getLevel(), ErrorCode.PROMOTION_LEVEL_LOW.getValue(), "等级未达开放要求");

        promotion066GamePlayPrediction.setReceiveTime(DateTimeUtil.currentSecond());
        promotion066GamePlayPredictionService.update(promotion066GamePlayPrediction);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.NEW_GAME_PLAY_PREDICTION_REWARD);

        promotion066GMsg.GResGetEveryDayReward.Builder builder = promotion066GMsg.GResGetEveryDayReward.newBuilder();
        builder.setReceiveTime(promotion066GamePlayPrediction.getReceiveTime());
        playerContext.write(CmdCode._13261, builder.build());
    }

}
