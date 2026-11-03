package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.exception.ErrorCodeException;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion031PvpWinsSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion031PvpWins;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion031Arena;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.ActivityRewardEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion031ArenaService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion031GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 竞技之巅
 *
 * @Author: CWJ
 * @Date: 2019/10/24
 **/
@Component
public class Promotion031ArenaHandler extends ProtocolHandler {
    @Autowired
    private Promotion031ArenaService promotion031ArenaService;
    @Autowired
    private Promotion031PvpWinsSysCache promotion031PvpWinsSysCache;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private EventBus eventBus;


    @CMD(id = CmdCode._13078)
    public void arenaData(PlayerContext playerContext, Promotion031GMsg.GReqPvpwinList req) {
        Promotion031Arena promotionInfo = promotion031ArenaService.getPromotionInfo(playerContext.getId());
        Promotion031GMsg.GResPvpwinList.Builder builder = Promotion031GMsg.GResPvpwinList.newBuilder();

        promotionInfo.getRewardRecord().forEach(idx -> {
            ObjectGMsg.PSMapData.Builder builder1 = ObjectGMsg.PSMapData.newBuilder();
            builder1.setKey(idx);
            builder1.setValue(1);
            builder.addList(builder1);
        });
        builder.setNvalue(promotionInfo.getWinCount());
        playerContext.write(CmdCode._13078, builder.build());

    }

    @CMD(id = CmdCode._13079)
    public void arenaReward(PlayerContext playerContext, Promotion031GMsg.GReqPvpwinTimesGift req) {
        Promotion031Arena promotion031Arena = promotion031ArenaService.getPromotionInfo(playerContext.getId());
        PromotionControl promotionControl = promotionControlService.getControl(PromotionType.JING_JI_ZHI_DIAN);

        CPromotion031PvpWins config = promotion031PvpWinsSysCache.getOrThrow(req.getIdx());
        if (config == null) {
            throw new ErrorCodeException(ErrorCode.CONFIG_NOT_EXISTS.getValue(), req.getIdx() + "");
        }

        if (!promotionControlService.isPromotionRunning(PromotionType.JING_JI_ZHI_DIAN)) {
            throw new ErrorCodeException(ErrorCode.PROMOTION_NOT_STARTING.getValue(), "PromotionType.JING_JI_ZHI_DIAN");
        }

        if (promotion031Arena.getWinCount() < config.getPvp_win_times()) {
            throw new ErrorCodeException(ErrorCode.ACHIEVEMENT_PROCESS_LOW.getValue(), "PromotionType.JING_JI_ZHI_DIAN");
        }

        if (promotion031Arena.getRewardRecord().contains(config.getIdx())) {
            throw new ErrorCodeException(ErrorCode.PROMOTION_ID_HAD_REWARD.getValue(), "PromotionType.JING_JI_ZHI_DIAN");
        }

        promotion031Arena.getRewardRecord().add(config.getIdx());
        promotion031ArenaService.updatePromotion(promotion031Arena);
        thingService.add(playerContext.getId(), config.getReward(), GameEvent.TAVERN_GOT);

        Promotion031GMsg.GReqPvpwinTimesGift.Builder builder = Promotion031GMsg.GReqPvpwinTimesGift.newBuilder();
        playerContext.write(CmdCode._13079, builder.build());

        eventBus.post(ActivityRewardEvent.of(playerContext.getId(), PromotionType.JING_JI_ZHI_DIAN, req.getIdx()));

    }


}
