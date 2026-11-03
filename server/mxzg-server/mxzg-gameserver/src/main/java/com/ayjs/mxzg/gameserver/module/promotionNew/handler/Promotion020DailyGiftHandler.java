/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion020DailyGift;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion020DailyGiftService;
import com.ayjs.mxzg.protocol.ObjectGMsg.PSMapData;
import com.ayjs.mxzg.protocol.Promotion020GMsg.GReqDailyGiftData;
import com.ayjs.mxzg.protocol.Promotion020GMsg.GReqDailyGiftReward;
import com.ayjs.mxzg.protocol.Promotion020GMsg.GResDailyGiftData;
import com.ayjs.mxzg.protocol.Promotion020GMsg.GResDailyGiftReward;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.Map.Entry;

/**
 * @author YY
 *
 */
@Controller
public class Promotion020DailyGiftHandler extends ProtocolHandler {

	@Autowired
	private Promotion020DailyGiftService promotion020DailyGiftService;
	@Autowired
	private ThingService thingService;
	@Autowired
	private SystemSysCache systemSysCache;

	@CMD(id = CmdCode._13311)
	public void scanDailyGiftData(PlayerContext playerContext, GReqDailyGiftData msg) {
		Promotion020DailyGift dailyGift = promotion020DailyGiftService.getPromotionInfo(playerContext.getId());
		
		GResDailyGiftData.Builder builder = GResDailyGiftData.newBuilder();
		builder.setHasReward(dailyGift.getHasReward());
		for(Entry<Integer, Integer> entry : dailyGift.getBuyInfo().entrySet()) {
			PSMapData.Builder model = PSMapData.newBuilder();
			model.setKey(entry.getKey());
			model.setValue(entry.getValue());
			builder.addData(model.build());
		}
		playerContext.write(CmdCode._13311, builder.build());
	}
	
	/**
	 * 旧协议20007
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._13312)
	public void getDailyGiftReward(PlayerContext playerContext, GReqDailyGiftReward msg) {
		Promotion020DailyGift dailyGift = promotion020DailyGiftService.getPromotionInfo(playerContext.getId());
		
		Asserts.isTrue(dailyGift.getHasReward() == 0, ErrorCode.PROMOTION_TOOK_REWARD.getValue(), "已经领取过该奖励");
		
		dailyGift.setHasReward(1);
		promotion020DailyGiftService.updatePromotion(dailyGift);
		
		thingService.add(playerContext.getId(), systemSysCache.getDailyGift(), GameEvent.DAILY_FREE_GIFT);
		
		GResDailyGiftReward.Builder builder = GResDailyGiftReward.newBuilder();
		builder.setHasReward(dailyGift.getHasReward());
		playerContext.write(CmdCode._13312, builder.build());
	}
	
}
