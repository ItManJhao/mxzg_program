/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion017DragonMarkTotalChargeSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion017DragonMarkTotalCharge;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion017ChargeInfo;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion017ChargeInfoService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.protocol.ObjectGMsg.PSMapData;
import com.ayjs.mxzg.protocol.Promotion017GMsg.GReqLimitedtimeRechargeReward;
import com.ayjs.mxzg.protocol.Promotion017GMsg.GReqPropomtionLimitedtimeReward;
import com.ayjs.mxzg.protocol.Promotion017GMsg.GResLimitedtimeRechargeReward;
import com.ayjs.mxzg.protocol.Promotion017GMsg.GResPropomtionLimitedtimeReward;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.Map;

/**
 * @author YY
 *
 */
@Controller
public class Promotion017TotalChargeHandler extends ProtocolHandler {

	@Autowired
	private Promotion017ChargeInfoService promotion017ChargeInfoService;
	@Autowired
	private Promotion017DragonMarkTotalChargeSysCache promotion017DragonMarkTotalChargeSysCache;
	@Autowired
	private PromotionControlService promotionControlService;
	@Autowired
    private ThingService thingService;

	/**
	 * 查看活动奖励
	 * 
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._13085)
	public void scanLimitRewardList(PlayerContext playerContext, GReqLimitedtimeRechargeReward msg) {
		Promotion017ChargeInfo chargeInfo = promotion017ChargeInfoService.getPromotionInfo(playerContext.getId());

		Map<Integer, CPromotion017DragonMarkTotalCharge> turnsMap = promotion017DragonMarkTotalChargeSysCache
				.getTurns(chargeInfo.getTurns());

		GResLimitedtimeRechargeReward.Builder builder = GResLimitedtimeRechargeReward.newBuilder();
		builder.setRmb(chargeInfo.getMoney());
		for (CPromotion017DragonMarkTotalCharge cCharge : turnsMap.values()) {
			PSMapData.Builder model = PSMapData.newBuilder();
			model.setKey(cCharge.getIdx());
			if (chargeInfo.getRewardInfo().containsKey(cCharge.getIdx())) {
				model.setValue(1);
			} else {
				model.setValue(0);
			}
			builder.addList(model.build());
		}
		playerContext.write(CmdCode._13085, builder.build());
	}

	/**
	 * 领取活动奖励
	 * 
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._13070)
	public void getLimitReward(PlayerContext playerContext, GReqPropomtionLimitedtimeReward msg) {
		if (!promotionControlService.isPromotionRunning(PromotionType.LEI_JI_CHONG_ZHI)) {
			//不在活动期间
			playerContext.writeError(ErrorCode.PROMOTION_NOT_RUNNING);
			return;
		}

		Promotion017ChargeInfo chargeInfo = promotion017ChargeInfoService.getPromotionInfo(playerContext.getId());

		CPromotion017DragonMarkTotalCharge cModel = promotion017DragonMarkTotalChargeSysCache
				.getTurnsIdx(chargeInfo.getTurns(), msg.getIdx());
		if (cModel == null) {
			//该奖励不属于当前活动
			playerContext.writeError(ErrorCode.PROMOTION_CONFIG_MISS);
			return;
		}

		if (chargeInfo.getRewardInfo().containsKey(cModel.getIdx())) {
			//已经领取过该奖励
			playerContext.writeError(ErrorCode.PROMOTION_TOOK_REWARD);
			return;
		}
		if (chargeInfo.getMoney() < cModel.getRmb()) {
			//还没有达到领取该奖励的要求
			playerContext.writeError(ErrorCode.PROMOTION_CANT_TAKE);
			return;
		}
		chargeInfo.getRewardInfo().put(cModel.getIdx(), 1);
		promotion017ChargeInfoService.updatePromotion(chargeInfo);
		// 领取奖励
        thingService.add(playerContext.getId(), cModel.getReward(), GameEvent.LIMITED_TIME_RECHARGE);
        
        playerContext.write(CmdCode._13070, GResPropomtionLimitedtimeReward.getDefaultInstance());
	}
}
