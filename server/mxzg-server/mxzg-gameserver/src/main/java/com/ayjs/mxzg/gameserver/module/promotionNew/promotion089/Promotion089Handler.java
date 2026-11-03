package com.ayjs.mxzg.gameserver.module.promotionNew.promotion089;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.promotion089.Promotion089Const;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion089.domain.Promotion089;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion089.service.Promotion089Service;
import com.ayjs.mxzg.protocol.Promotion089GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * 圣诞感恩信
 */
@Controller
public class Promotion089Handler extends ProtocolHandler {
    @Autowired
    private Promotion089Service promotion089Service;
    @Autowired
    private ThingService thingService;
    @Autowired
    private Promotion089Const promotion089Const;


    @CMD(id = CmdCode._76161)
    public void getInfo(PlayerContext playerContext, Promotion089GMsg.GReqChristmasNote msg) {
        Promotion089 promotionInfo = promotion089Service.getPromotionInfo(playerContext.getId());
        Promotion089GMsg.GResChristmasNote.Builder builder = Promotion089GMsg.GResChristmasNote.newBuilder();
        builder.setRewardTime(promotionInfo.getRewardTime());
        playerContext.write(CmdCode._76161, builder.build());
    }



    @CMD(id = CmdCode._76162)
    public void getReward(PlayerContext playerContext, Promotion089GMsg.GReqChristmasNoteReward msg) {
        Asserts.isTrue(promotion089Service.isOpen(),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(),
                String.format("活动未开启"));
        Promotion089 promotionInfo = promotion089Service.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(!TimeDateUtil.isToday(promotionInfo.getRewardTime()),
                ErrorCode.PROMOTION_089_HAD_READ.getValue(),
                String.format("今日{%s}已领取", promotionInfo.getRewardTime()));

        promotionInfo.setRewardTime(TimeDateUtil.getCurrentTimeInt());
        promotion089Service.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), promotion089Const.getReward(), GameEvent.PROMOTION_089_NOTE);

        Promotion089GMsg.GResChristmasNoteReward.Builder builder = Promotion089GMsg.GResChristmasNoteReward.newBuilder();
        builder.setRewardTime(promotionInfo.getRewardTime());
        playerContext.write(CmdCode._76162, builder.build());
    }
}
