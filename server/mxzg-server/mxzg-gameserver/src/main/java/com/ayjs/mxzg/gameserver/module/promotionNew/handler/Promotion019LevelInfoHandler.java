/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion019MainLevelRewardSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion019MainLevelReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion019LevelInfo;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion019LevelInfoService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.Promotion019SystemInfo;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.Promotion019GMsg.GReqLevelUpGift;
import com.ayjs.mxzg.protocol.Promotion019GMsg.GReqLevelUpGiftList;
import com.ayjs.mxzg.protocol.Promotion019GMsg.GResLevelUpGift;
import com.ayjs.mxzg.protocol.Promotion019GMsg.GResLevelUpGiftList;
import com.ayjs.mxzg.protocol.Promotion019GMsg.PSLevelUpGiftData;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.Map;

/**
 * @author YY
 *
 */
@Controller
public class Promotion019LevelInfoHandler extends ProtocolHandler {
	
	
	@Autowired
	private Promotion019LevelInfoService promotion019LevelInfoService;
	@Autowired
	private Promotion019MainLevelRewardSysCache promotion019MainLevelRewardSysCache;
	@Autowired
	private PromotionControlService promotionControlService;
	@Autowired
	private RoleService roleService;
	@Autowired
	private ThingService thingService;
	/**
	 * 获取等级礼包数据
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._13019)
	public void getLevelInfo(PlayerContext playerContext, GReqLevelUpGiftList msg) {
		
		Promotion019LevelInfo levelInfo = promotion019LevelInfoService.getPromotionInfo(playerContext.getId());
		
		Map<Integer, CPromotion019MainLevelReward> systemRewards = promotion019MainLevelRewardSysCache
				.getTurnsReward(levelInfo.getTurns());
		
		Promotion019SystemInfo systemInfo = promotion019LevelInfoService.getSystemInfo();
		
		GResLevelUpGiftList.Builder builder = GResLevelUpGiftList.newBuilder();
		for(CPromotion019MainLevelReward cReward : systemRewards.values()) {
			Integer takeCount = systemInfo.getTakeMap().get(cReward.getIdx());
			if(takeCount == null) {
				takeCount = 0;
			}
			Integer hasTask = levelInfo.getLevelInfo().get(cReward.getIdx());
			if(hasTask == null) {
				hasTask = 0;
			}
			PSLevelUpGiftData.Builder model = PSLevelUpGiftData.newBuilder();
			model.setIdx(cReward.getIdx());
			model.setBuyCount(cReward.getTotal_num() - takeCount);
			model.setIsObtain(hasTask);
			builder.addData(model.build());
		}
		playerContext.write(CmdCode._13019, builder.build());
	}
	/**
	 * 领取等级礼包
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._13020)
	public void getLevelReward(PlayerContext playerContext, GReqLevelUpGift msg) {
		if(!promotionControlService.isPromotionRunning(PromotionType.SHENG_JI_YOU_LI)) {
			//不在活动期间
			playerContext.writeError(ErrorCode.PROMOTION_NOT_RUNNING);
			return;
		}
		
		Promotion019LevelInfo levelInfo = promotion019LevelInfoService.getPromotionInfo(playerContext.getId());
		
		Map<Integer, CPromotion019MainLevelReward> turnsRewardMap = promotion019MainLevelRewardSysCache.getTurnsReward(levelInfo.getTurns());
		CPromotion019MainLevelReward cLevelReward = turnsRewardMap.get(msg.getGiftId());
		if(cLevelReward == null) {
			//该奖励不属于当前活动
			playerContext.writeError(ErrorCode.PROMOTION_CONFIG_MISS);
			return;
		}
		
		Integer takeFlag = levelInfo.getLevelInfo().get(cLevelReward.getIdx());
		if(takeFlag != null) {
			//你已经领取过该奖励
			playerContext.writeError(ErrorCode.PROMOTION_TOOK_REWARD);
			return;
		}
		
		Role role = roleService.getOrThrow(playerContext.getId());

		synchronized (this) {
			Promotion019SystemInfo systemInfo = promotion019LevelInfoService.getSystemInfo();
			Integer takeCount = systemInfo.getTakeMap().get(cLevelReward.getIdx());
			if(takeCount == null) {
				takeCount = 0;
			}
			if(takeCount >= cLevelReward.getTotal_num()) {
				//该活动奖励已经被领光
				playerContext.writeError(ErrorCode.PROMOTION_REWARD_EMPTY);
				return;
			}
			if(role.getLevel() < cLevelReward.getMain_level()) {
				//你的等级还没有达到要求
				playerContext.writeError(ErrorCode.PROMOTION_LEVEL_LOW);
				return;
			}
			//标记已领取
			levelInfo.getLevelInfo().put(cLevelReward.getIdx(), 1);
			promotion019LevelInfoService.updatePromotion(levelInfo);
			
			//记录已领取人数+1
			systemInfo.getTakeMap().put(cLevelReward.getIdx(), takeCount + 1);
			PromotionControl promotionControl = promotionControlService.getControl(PromotionType.SHENG_JI_YOU_LI);
			promotionControl.setExtraInfo(JsonUtil.toJson(systemInfo));
			promotionControlService.updateControl(promotionControl);

			thingService.add(role.getId(), cLevelReward.getReward(), GameEvent.LEVEL_REWARD);
		}
		
		GResLevelUpGift.Builder builder = GResLevelUpGift.newBuilder();
		builder.setIdx(cLevelReward.getIdx());
		builder.setIsSuccess(1);
		playerContext.write(CmdCode._13020, builder.build());
	}
}
