package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion063ElfWeekCardSysCache;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion058HighWeeksCard;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion063ElfWeekCard;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion063ElfWeekCardService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion058GMsg;
import com.ayjs.mxzg.protocol.Promotion063GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * 精灵周卡
 * @author hyx
 */
@Controller
public class Promotion063ElfWeekCardHandler extends ProtocolHandler {

    @Autowired
    private Promotion063ElfWeekCardService promotion063ElfWeekCardService;

    @CMD(id = CmdCode._13240)
    public void sendElfWeekCardBuyInfo(PlayerContext playerContext , Promotion063GMsg.GReqElfWeeksCardInfo msg){
        promotion063ElfWeekCardService.sendPromotionInfo(playerContext.getId());
    }

}
