/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion024WeeklyGift;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion024WeeklyGiftService;
import com.ayjs.mxzg.protocol.ObjectGMsg.PSMapData;
import com.ayjs.mxzg.protocol.Promotion024GMsg.GReqWeeklyGiftData;
import com.ayjs.mxzg.protocol.Promotion024GMsg.GResWeeklyGiftData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.Map.Entry;

/**
 * @author YY
 *
 */
@Controller
public class Promotion024WeeklyGiftHandler extends ProtocolHandler {

	@Autowired
	private Promotion024WeeklyGiftService promotion024WeeklyGiftService;

	@CMD(id = CmdCode._13351)
	public void scanWeeklyBuyInfo(PlayerContext playerContext, GReqWeeklyGiftData msg) {
		Promotion024WeeklyGift weeklyGift = promotion024WeeklyGiftService.getPromotionInfo(playerContext.getId());
		GResWeeklyGiftData.Builder builder = GResWeeklyGiftData.newBuilder();
		for(Entry<Integer, Integer> entry : weeklyGift.getBuyInfo().entrySet()) {
			PSMapData.Builder model = PSMapData.newBuilder();
			model.setKey(entry.getKey());
			model.setValue(entry.getValue());
			builder.addList(model.build());
		}
		playerContext.write(CmdCode._13351, builder.build());
		
	}
}
