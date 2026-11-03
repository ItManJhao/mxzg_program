/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion016DragonMarkShopsSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion016DragonMarkShops;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion016DragonInfo;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion016DragonInfoService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.protocol.ObjectGMsg.PSMapData;
import com.ayjs.mxzg.protocol.Promotion016GMsg.GReqExchangeBuy;
import com.ayjs.mxzg.protocol.Promotion016GMsg.GReqExchangeList;
import com.ayjs.mxzg.protocol.Promotion016GMsg.GResExchangeBuy;
import com.ayjs.mxzg.protocol.Promotion016GMsg.GResExchangeList;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.Map.Entry;

/**
 * @author YY
 *
 */
@Controller
public class Promotion016DragonHandler extends ProtocolHandler {

    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private Promotion016DragonInfoService promotion016DragonInfoService;
    @Autowired
    private Promotion016DragonMarkShopsSysCache promotion016DragonMarkShopsSysCache;
    @Autowired
    private ThingService thingService;

    @CMD(id = CmdCode._13071)
    public void dragonExchangeList(PlayerContext playerContext, GReqExchangeList msg) {

        Promotion016DragonInfo dragonInfo = promotion016DragonInfoService.getPromotionInfo(playerContext.getId());

        GResExchangeList.Builder builder = GResExchangeList.newBuilder();
        for (Entry<Integer, Integer> entry : dragonInfo.getDragonInfo().entrySet()) {
            PSMapData.Builder model = PSMapData.newBuilder();
            model.setKey(entry.getKey());
            model.setValue(entry.getValue());
            builder.addList(model.build());
        }
        playerContext.write(CmdCode._13071, builder.build());
    }

    @CMD(id = CmdCode._13072)
    public void dragonExchangeBuy(PlayerContext playerContext, GReqExchangeBuy msg) {
        if (!promotionControlService.isPromotionRunning(PromotionType.XIAN_SHI_DUI_HUAN)) {
            //不在活动期间
            playerContext.writeError(ErrorCode.PROMOTION_NOT_RUNNING);
            return;
        }
        Promotion016DragonInfo dragonInfo = promotion016DragonInfoService.getPromotionInfo(playerContext.getId());

        CPromotion016DragonMarkShops cDragonMarkShops = promotion016DragonMarkShopsSysCache
                .getTurnsIdx(dragonInfo.getTurns(), msg.getIdx());
        if (cDragonMarkShops == null) {
            //该奖励不属于当前活动
            playerContext.writeError(ErrorCode.PROMOTION_CONFIG_MISS);
            return;
        }

        int num = msg.getNum();

        Integer count = dragonInfo.getDragonInfo().get(cDragonMarkShops.getIdx());
        if (count == null) {
            count = 0;
        }
        if (count + num > cDragonMarkShops.getLimit()) {
            //已经没有兑换次数
            playerContext.writeError(ErrorCode.PROMOTION_CANT_CHANGE);
            return;
        }

        thingService.cost(playerContext.getId(), ImmutableThingUtil.multiplyThing(cDragonMarkShops.getCost(), num), GameEvent.EXCHANGE_BUY);

        dragonInfo.getDragonInfo().put(cDragonMarkShops.getIdx(), count + num);
        promotion016DragonInfoService.updatePromotion(dragonInfo);

        thingService.add(playerContext.getId(), ImmutableThingUtil.multiplyThing(cDragonMarkShops.getItem(), num), GameEvent.EXCHANGE_BUY);

        GResExchangeBuy.Builder builder=GResExchangeBuy.newBuilder();
        builder.setIdx(msg.getIdx());
        builder.setNum(msg.getNum());

        playerContext.write(CmdCode._13072, builder.build());
    }
}
