/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import java.util.List;

import cn.hutool.core.collection.CollectionUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion006InvestSysCache;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion006Invest;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion006InvestService;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MonthCardInvest;
import com.ayjs.mxzg.protocol.Promotion006GMsg.GReqInvestGain;
import com.ayjs.mxzg.protocol.Promotion006GMsg.GReqInvestList;
import com.ayjs.mxzg.protocol.Promotion006GMsg.GResInvestGain;
import com.ayjs.mxzg.protocol.Promotion006GMsg.GResInvestList;
import com.ayjs.mxzg.protocol.Promotion006GMsg.ResInvestData;
import com.ayjs.mxzg.template.constant.ErrorCode;

/**
 * @author YY
 * 月度基金
 */
@Controller
public class Promotion006MonthInvestHandler extends ProtocolHandler {

    @Autowired
    private Promotion006InvestService promotion006InvestService;
    @Autowired
    private Promotion006InvestSysCache promotion006InvestSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private SystemSysCache systemSysCache;

    /**
     * 查看月卡信息
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13062)
    public void investList(PlayerContext playerContext, GReqInvestList msg) {
        GResInvestList.Builder builder = GResInvestList.newBuilder();

        Promotion006Invest invest = promotion006InvestService.getInvest(playerContext.getId());

        int nowTime = DateTimeUtil.currentSecond();

        builder.setStatus(invest.getShowType());
        builder.setStartTime(invest.getStartTime());
        builder.setEndTime(invest.getEndTime());

        for (MonthCardInvest monthCard : invest.getInvest().values()) {
            ResInvestData.Builder data = ResInvestData.newBuilder();
            data.setType(monthCard.getType());
            data.setReceiveDay(monthCard.getReceiveDay());
            int zeroTime = TimeDateUtil.getSomedayZeroInt(monthCard.getBuyTime());
            int reachDay = Math.min((nowTime - zeroTime) / TimeDateUtil.ONEDAYINT + 1, promotion006InvestSysCache.getMaxDay());
            data.setReachDay(promotion006InvestSysCache.getMaxDay());
            data.setIsTodayGot(monthCard.getReceiveDay() == reachDay);
            builder.addList(data.build());
        }
        playerContext.write(CmdCode._13062, builder.build());
    }

    /**
     * 领取月卡基金奖励
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13063)
    public void investGain(PlayerContext playerContext, GReqInvestGain msg) {

        Promotion006Invest invest = promotion006InvestService.getInvest(playerContext.getId());

        MonthCardInvest monthCard = invest.getInvest().get(msg.getType());
        Asserts.isTrue(monthCard != null, ErrorCode.MONTH_INVEST_MISS.getValue(), "还没有购买该基金" + msg.getType());

        int zeroTime = TimeDateUtil.getSomedayZeroInt(monthCard.getBuyTime());
        int nowTime = TimeDateUtil.getCurrentTimeInt();
        //可以领取到的天数
        int reachDay =  Math.min((nowTime - zeroTime) / TimeDateUtil.ONEDAYINT + 1, promotion006InvestSysCache.getMaxDay());

        List<ImmutableThing> list = promotion006InvestSysCache.getByTypeDay(msg.getType(), monthCard.getReceiveDay(), reachDay);
        Asserts.isTrue(CollectionUtil.isNotEmpty(list), ErrorCode.MONTH_INVEST_EMPTY.getValue(), "没有基金奖励可以领取");

        monthCard.setReceiveDay(reachDay);
        promotion006InvestService.updateInvest(invest);

        List<ImmutableThing> rewardList = ImmutableThingUtil.mergeThing(list);
        thingService.add(playerContext.getId(), rewardList, GameEvent.INVEST_GAIN);

        GResInvestGain.Builder builder = GResInvestGain.newBuilder();
        builder.setType(monthCard.getType());
        builder.setReceiveDay(monthCard.getReceiveDay());
        builder.setReachDay(promotion006InvestSysCache.getMaxDay());
        builder.setIsTodayGot(true);
        playerContext.write(CmdCode._13063, builder.build());
    }
}
