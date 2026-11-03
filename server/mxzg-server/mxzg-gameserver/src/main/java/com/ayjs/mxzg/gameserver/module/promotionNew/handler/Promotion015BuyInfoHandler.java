/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion015BuyInfo;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion015BuyInfoService;
import com.ayjs.mxzg.protocol.ObjectGMsg.PSMapData;
import com.ayjs.mxzg.protocol.Promotion015GMsg.GReqScanBuyInfo;
import com.ayjs.mxzg.protocol.Promotion015GMsg.GResScanBuyInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.Map.Entry;

/**
 * @author YY
 *
 */
@Controller
public class Promotion015BuyInfoHandler extends ProtocolHandler {

	@Autowired
	private Promotion015BuyInfoService promotion015BuyInfoService;

	@CMD(id = CmdCode._13301)
	public void scanBuyInfo(PlayerContext playerContext, GReqScanBuyInfo msg) {
		GResScanBuyInfo.Builder builder = GResScanBuyInfo.newBuilder();
		
		Promotion015BuyInfo buyInfo = promotion015BuyInfoService.getPromotionInfo(playerContext.getId());
		
		for(Entry<Integer, Integer> entry : buyInfo.getBuyInfo().entrySet()) {
			PSMapData.Builder model = PSMapData.newBuilder();
			model.setKey(entry.getKey());
			model.setValue(entry.getValue());
			builder.addData(model.build());
		}
		playerContext.write(CmdCode._13301, builder.build());
	}
}
