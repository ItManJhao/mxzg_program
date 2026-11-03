/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion023MonthGift;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion023MonthGiftService;
import com.ayjs.mxzg.protocol.ObjectGMsg.PSMapData;
import com.ayjs.mxzg.protocol.Promotion023GMsg.GReqMonthGiftData;
import com.ayjs.mxzg.protocol.Promotion023GMsg.GResMonthGiftData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.Map.Entry;

/**
 * @author YY
 *
 */
@Controller
public class Promotion023MonthGiftHandler extends ProtocolHandler {

	@Autowired
	private Promotion023MonthGiftService promotion023MonthGiftService;

	@CMD(id = CmdCode._13341)
	public void scanMonthGiftData(PlayerContext playerContext, GReqMonthGiftData msg) {
		GResMonthGiftData.Builder builder = GResMonthGiftData.newBuilder();
		
		Promotion023MonthGift monthGift = promotion023MonthGiftService.getPromotionInfo(playerContext.getId());
		
		for(Entry<Integer, Integer> entry : monthGift.getBuyInfo().entrySet()) {
			PSMapData.Builder model = PSMapData.newBuilder();
			model.setKey(entry.getKey());
			model.setValue(entry.getValue());
			builder.addList(model.build());
		}
		playerContext.write(CmdCode._13341, builder.build());
	}
}
