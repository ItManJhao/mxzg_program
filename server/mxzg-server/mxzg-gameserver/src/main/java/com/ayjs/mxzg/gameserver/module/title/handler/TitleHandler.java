/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.title.handler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.title.domain.Title;
import com.ayjs.mxzg.gameserver.module.title.service.TitleService;
import com.ayjs.mxzg.gameserver.module.title.struct.TitleData;
import com.ayjs.mxzg.protocol.TitleGMsg.GReqScanTitleList;
import com.ayjs.mxzg.protocol.TitleGMsg.GResScanTitleList;
import com.ayjs.mxzg.protocol.TitleGMsg.PSTitle;

/**
 * @author YY
 *
 */
@Controller
public class TitleHandler extends ProtocolHandler {

	@Autowired
	private TitleService titleService;
	
	@CMD(id = CmdCode._55001)
	public void scanTitles(PlayerContext playerContext, GReqScanTitleList msg) {
		Title title = titleService.getTitle(playerContext.getId());
		
		GResScanTitleList.Builder builder = GResScanTitleList.newBuilder();
		for(TitleData titleData : title.getTitles().values()) {
			PSTitle.Builder model = PSTitle.newBuilder();
			model.setIdx(titleData.getId());
			model.setEndTime(titleData.getEndTime());
			builder.addTitles(model.build());
		}
		playerContext.write(CmdCode._55001, builder.build());
	}
}
