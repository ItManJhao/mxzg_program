/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion049RechargeDaysSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion049RechargeDays;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion049RechargeDays;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion049RechargeDaysService;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.RechargeDays;
import com.ayjs.mxzg.protocol.Promotion049GMsg.GReqRechargeDaysList;
import com.ayjs.mxzg.protocol.Promotion049GMsg.GReqRechargeDaysReward;
import com.ayjs.mxzg.protocol.Promotion049GMsg.GResRechargeDaysList;
import com.ayjs.mxzg.protocol.Promotion049GMsg.GResRechargeDaysReward;
import com.ayjs.mxzg.protocol.Promotion049GMsg.PSRechargeDaysInfo;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * @author YY
 *
 */
@Controller
public class Promotion049RechargeDaysHandler extends ProtocolHandler {

	
	@Autowired
	private Promotion049RechargeDaysService promotion049RechargeDaysService;
	@Autowired
	private SystemSysCache systemSysCache;
	@Autowired
	private ThingService thingService;
	@Autowired
	private Promotion049RechargeDaysSysCache promotion049RechargeDaysSysCache;
	
	/**
	 * 旧协议13013
	 * @param playerContext
	 */
	@CMD(id = CmdCode._13171)
	public void scanRechargeDaysInfo(PlayerContext playerContext, GReqRechargeDaysList msg) {
		Promotion049RechargeDays info = promotion049RechargeDaysService.getPromotionInfo(playerContext.getId());
		
		GResRechargeDaysList.Builder builder = GResRechargeDaysList.newBuilder();
		for(RechargeDays rechargeDays : info.getDaysMap().values()) {
			builder.addList(serializeRechargeDay(rechargeDays));
		}
		playerContext.write(CmdCode._13171, builder.build());
	}
	
	
	@CMD(id = CmdCode._13172)
	public void getRechargeDaysReward(PlayerContext playerContext, GReqRechargeDaysReward msg) {
		Promotion049RechargeDays info = promotion049RechargeDaysService.getPromotionInfo(playerContext.getId());
		
		RechargeDays rechargeDays = info.getDaysMap().get(msg.getDay());
		if(rechargeDays == null || rechargeDays.getMoney() < systemSysCache.getRechargeDaysAtLeastRmb()) {
			playerContext.writeError(ErrorCode.PROMOTION_CANT_TAKE);
			return;
		}
		
		if(rechargeDays.getHasReward() != 0) {
			playerContext.writeError(ErrorCode.PROMOTION_TOOK_REWARD);
			return;
		}
		
		CPromotion049RechargeDays cRechargeDays = promotion049RechargeDaysSysCache.getOrThrow(msg.getDay());
		
		rechargeDays.setHasReward(1);
		promotion049RechargeDaysService.update(info);
		
		thingService.add(playerContext.getId(), cRechargeDays.getItem(), GameEvent.RECHARGE_DAYS_REWARD);
		
		GResRechargeDaysReward.Builder builder = GResRechargeDaysReward.newBuilder();
		builder.setData(serializeRechargeDay(rechargeDays));
		playerContext.write(CmdCode._13172, builder.build());
	}
	
	
	private PSRechargeDaysInfo serializeRechargeDay(RechargeDays rechargeDays) {
		PSRechargeDaysInfo.Builder builder = PSRechargeDaysInfo.newBuilder();
		builder.setDay(rechargeDays.getDay());
		builder.setMoney(rechargeDays.getMoney());
		builder.setHasReward(rechargeDays.getHasReward());
		return builder.build();
	}
}
