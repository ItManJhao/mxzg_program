/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.welfare.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.welfare.domain.GiftPackDay;
import com.ayjs.mxzg.gameserver.module.welfare.domain.GiftPackMonth;
import com.ayjs.mxzg.gameserver.module.welfare.service.GiftPackDayService;
import com.ayjs.mxzg.gameserver.module.welfare.service.GiftPackMonthService;
import com.ayjs.mxzg.protocol.ObjectGMsg.PSMapData;
import com.ayjs.mxzg.protocol.WelfareGMsg.GReqDailyWelfareList;
import com.ayjs.mxzg.protocol.WelfareGMsg.GReqMouthWelfareList;
import com.ayjs.mxzg.protocol.WelfareGMsg.GResDailyWelfareList;
import com.ayjs.mxzg.protocol.WelfareGMsg.GResMouthWelfareList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * @author YY
 *
 */
@Controller
public class WelfareHandler extends ProtocolHandler {

	@Autowired
	private GiftPackDayService giftPackDayService;
	@Autowired
	private GiftPackMonthService giftPackMonthService;

	@CMD(id = CmdCode._26001)
	public void mouthWelfareList(PlayerContext playerContext, GReqMouthWelfareList msg) {
		GResMouthWelfareList.Builder builder = GResMouthWelfareList.newBuilder();
		for(GiftPackMonth month : giftPackMonthService.getGiftPackMonths(playerContext.getId())) {
			PSMapData.Builder ele = PSMapData.newBuilder();
			ele.setKey(month.getGiftPackId());
			ele.setValue(month.getNum());
			builder.addList(ele.build());
		}
		playerContext.write(CmdCode._26001, builder.build());
	}

	@CMD(id = CmdCode._26002)
	public void dailyWelfareList(PlayerContext playerContext, GReqDailyWelfareList msg) {
		GResDailyWelfareList.Builder builder = GResDailyWelfareList.newBuilder();
		for(GiftPackDay day : giftPackDayService.getGiftPackDays(playerContext.getId())) {
			PSMapData.Builder ele = PSMapData.newBuilder();
			ele.setKey(day.getGiftPackId());
			ele.setValue(day.getNum());
			builder.addList(ele.build());
		}
		playerContext.write(CmdCode._26002, builder.build());
	}
	
}
