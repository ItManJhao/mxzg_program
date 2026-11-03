/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion021DailyFirstRechargeSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion021DailyFirstRecharge;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion021DailyCharge;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion021DailyChargeService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.DailyFirstRecharge;
import com.ayjs.mxzg.protocol.Promotion021GMsg.GReqDailyChargeData;
import com.ayjs.mxzg.protocol.Promotion021GMsg.GReqDailyChargeReward;
import com.ayjs.mxzg.protocol.Promotion021GMsg.GResDailyChargeData;
import com.ayjs.mxzg.protocol.Promotion021GMsg.GResDailyChargeReward;
import com.ayjs.mxzg.protocol.Promotion021GMsg.PSDailyFirstRecharge;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * @author YY
 *
 */
@Controller
public class Promotion021DailyChargeHandler extends ProtocolHandler {

	@Autowired
	private Promotion021DailyChargeService promotion021DailyChargeService;
	@Autowired
	private Promotion021DailyFirstRechargeSysCache promotion021DailyFirstRechargeSysCache;
	@Autowired
	private PromotionControlService promotionControlService;
	@Autowired
	private ThingService thingService;

	/**
	 * 旧协议20008
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._13321)
	public void scanDailyChargeInfo(PlayerContext playerContext, GReqDailyChargeData msg) {
		Promotion021DailyCharge dailyCharge = promotion021DailyChargeService.getPromotionInfo(playerContext.getId());
		
		GResDailyChargeData.Builder builder = GResDailyChargeData.newBuilder();
		for(DailyFirstRecharge data : dailyCharge.getRecharges().values()) {
			PSDailyFirstRecharge.Builder res = PSDailyFirstRecharge.newBuilder();
			res.setType(data.getType());
			res.setMoney(data.getMoney());
			res.setStatus(data.getStatus());
			builder.addList(res.build());
		}
		playerContext.write(CmdCode._13321, builder.build());
	}

	/**
	 * 旧协议20009
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._13322)
	public void getDailyChargeReward(PlayerContext playerContext, GReqDailyChargeReward msg) {
		if(!promotionControlService.isPromotionRunning(PromotionType.MEI_RI_SHOU_CHONG)) {
			//不在活动期间
			playerContext.writeError(ErrorCode.PROMOTION_NOT_RUNNING);
			return;
		}
		Promotion021DailyCharge dailyCharge = promotion021DailyChargeService.getPromotionInfo(playerContext.getId());
		
		DailyFirstRecharge dailyFirstRecharge = dailyCharge.getRecharges().get(msg.getType());
		if(dailyFirstRecharge == null) {
			//未达到奖励领取要求
			playerContext.writeError(ErrorCode.PROMOTION_CANT_TAKE);
			return;
		}
		if(dailyFirstRecharge.getStatus() != 0) {
			//已经领取奖励
			playerContext.writeError(ErrorCode.PROMOTION_TOOK_REWARD);
			return;
		}
		CPromotion021DailyFirstRecharge cRecharge = promotion021DailyFirstRechargeSysCache.getByTurns(dailyCharge.getTurns(), msg.getType());
		if (cRecharge == null) {
			//未找到活动配置
			playerContext.writeError(ErrorCode.PROMOTION_CONFIG_MISS);
			return;
		}
		if (cRecharge.getRmb() > dailyFirstRecharge.getMoney()) {
			//未达到奖励领取要求
			playerContext.writeError(ErrorCode.PROMOTION_CANT_TAKE);
			return;
		}
		
		dailyFirstRecharge.setStatus(1);
		promotion021DailyChargeService.updatePromotion(dailyCharge);
		
		thingService.add(playerContext.getId(), cRecharge.getItem(), GameEvent.FIRST_RECHARGE_REWARD);
		
		GResDailyChargeReward.Builder builder = GResDailyChargeReward.newBuilder();
		builder.setType(msg.getType());
		playerContext.write(CmdCode._13322, builder.build());
	}
}
