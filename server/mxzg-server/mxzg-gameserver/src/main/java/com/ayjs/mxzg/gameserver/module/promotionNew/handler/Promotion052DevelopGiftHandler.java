package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import cn.hutool.core.util.StrUtil;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion052DevelopGiftSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion052DevelopGift;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion052DevelopGift;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion052DevelopGiftService;
import com.ayjs.mxzg.protocol.Promotion052GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.Map;

/**
 * 超值养成礼包
 */
@Controller
public class Promotion052DevelopGiftHandler extends ProtocolHandler {

    @Autowired
    private Promotion052DevelopGiftService promotion052DevelopGiftService;
    @Autowired
    private Promotion052DevelopGiftSysCache promotion052DevelopGiftSysCache;
    @Autowired
    private ThingService thingService;

    /**
     * 养成礼包信息
     */
    @CMD(id = CmdCode._44001)
    public void developGiftList(PlayerContext playerContext, Promotion052GMsg.GReqDevelopGiftList msg) {

        Promotion052DevelopGift promotion052DevelopGift = promotion052DevelopGiftService.getAndRefresh(playerContext.getId());

        Promotion052GMsg.GResDevelopGiftList.Builder builder = Promotion052GMsg.GResDevelopGiftList.newBuilder();
        builder.setRefreshDateTime(promotion052DevelopGift.getRefreshDate());
        builder.addAllData(promotion052DevelopGiftService.serializeDevelopGiftData(promotion052DevelopGift.getGifts()));

        playerContext.write(CmdCode._44001, builder.build());
    }

    /**
     * 购买礼包
     */
    @CMD(id = CmdCode._44002)
    public void buyDevelopGift(PlayerContext playerContext, Promotion052GMsg.GReqBuyDevelopGift msg) {
        int type = msg.getType();
        int level = msg.getLevel();

        Asserts.isTrue(type > 0 && level > 0, ErrorCode.ERROR_PARAM.getValue(),
                () -> StrUtil.format("buy Develop Gift type:{},level:{}", type, level));

        CPromotion052DevelopGift cPromotion052DevelopGift = promotion052DevelopGiftSysCache.getDevelopGift(type, level);
        Promotion052DevelopGift promotion052DevelopGift = promotion052DevelopGiftService.getAndRefresh(playerContext.getId());

        // 判断是否已经买过
        Map<Integer, Integer> gifts = promotion052DevelopGift.getGifts();

        Integer existGift = gifts.getOrDefault(type, 0);
        // gift level 写死了自增1
        Asserts.isTrue(level == existGift + 1, ErrorCode.GIFT_PURCHASED.getValue(),
                () -> StrUtil.format("gift purchased type:{},level:{}", type, level));

        // 扣钱
        int combine = thingService.combine(cPromotion052DevelopGift.getCost());
        // 判断免费的情况
        if (combine > 0) {
            thingService.cost(playerContext.getId(), cPromotion052DevelopGift.getCost(), GameEvent.DevelopGift);
        }

        // 修改数据
        gifts.put(type, level);
        promotion052DevelopGiftService.update(promotion052DevelopGift);

        // 给奖励
        thingService.add(playerContext.getId(), cPromotion052DevelopGift.getReward(), GameEvent.DevelopGift);

        Promotion052GMsg.GResBuyDevelopGift.Builder builder = Promotion052GMsg.GResBuyDevelopGift.newBuilder();
        builder.setData(promotion052DevelopGiftService.serializeDevelopGift(type, level));
        playerContext.write(CmdCode._44002, builder.build());

    }
}
