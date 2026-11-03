/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion060RechargeDaysSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion060RechargeDays;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion060RechargeDays;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion060RechargeDaysService;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.RechargeDays;
import com.ayjs.mxzg.protocol.Promotion049GMsg.PSRechargeDaysInfo;
import com.ayjs.mxzg.protocol.Promotion060GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * @author YY
 *
 */
@Controller
public class Promotion060RechargeDaysHandler extends ProtocolHandler {


    @Autowired
    private Promotion060RechargeDaysService Promotion060RechargeDaysService;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private Promotion060RechargeDaysSysCache Promotion060RechargeDaysSysCache;

    /**
     * @param playerContext
     */
    @CMD(id = CmdCode._69001)
    public void scanRechargeDaysInfo(PlayerContext playerContext, Promotion060GMsg.GReqRechargeDaysBList msg) {
        Promotion060RechargeDays info = Promotion060RechargeDaysService.getPromotionInfo(playerContext.getId());

        Promotion060GMsg.GResRechargeDaysBList.Builder builder = Promotion060GMsg.GResRechargeDaysBList.newBuilder();
        for (RechargeDays rechargeDays : info.getDaysMap().values()) {
            builder.addList(serializeRechargeDay(rechargeDays));
        }
        playerContext.write(CmdCode._69001, builder.build());
    }


    @CMD(id = CmdCode._69002)
    public void getRechargeDaysReward(PlayerContext playerContext, Promotion060GMsg.GReqRechargeDaysBReward msg) {
        Promotion060RechargeDays info = Promotion060RechargeDaysService.getPromotionInfo(playerContext.getId());

        RechargeDays rechargeDays = info.getDaysMap().get(msg.getDay());
        if (rechargeDays == null || rechargeDays.getMoney() < systemSysCache.getHigherRechargeDaysAtLeastRmb()) {
            playerContext.writeError(ErrorCode.PROMOTION_CANT_TAKE);
            return;
        }

        if (rechargeDays.getHasReward() != 0) {
            playerContext.writeError(ErrorCode.PROMOTION_TOOK_REWARD);
            return;
        }

        CPromotion060RechargeDays cRechargeDays = Promotion060RechargeDaysSysCache.getOrThrow(msg.getDay());

        rechargeDays.setHasReward(1);
        Promotion060RechargeDaysService.update(info);

        thingService.add(playerContext.getId(), cRechargeDays.getItem(), GameEvent.RECHARGE_DAYS2_REWARD);

        Promotion060GMsg.GResRechargeDaysBReward.Builder builder = Promotion060GMsg.GResRechargeDaysBReward.newBuilder();
        builder.setData(serializeRechargeDay(rechargeDays));
        playerContext.write(CmdCode._69002, builder.build());
    }


    private PSRechargeDaysInfo serializeRechargeDay(RechargeDays rechargeDays) {
        PSRechargeDaysInfo.Builder builder = PSRechargeDaysInfo.newBuilder();
        builder.setDay(rechargeDays.getDay());
        builder.setMoney(rechargeDays.getMoney());
        builder.setHasReward(rechargeDays.getHasReward());
        return builder.build();
    }
}
