package com.ayjs.mxzg.cross.web.api;

import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.cross.module.champion.service.ChampionCrossService;
import com.ayjs.mxzg.cross.web.constant.WebErrorCode;
import com.ayjs.mxzg.cross.web.support.WebResult;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionCrossCleanBiu;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ResChampionCrossCleanBiu.ResChampionCrossCleanBiuBuilder;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/champion")
public class ChampionApi {
	
	@Autowired
	private ChampionCrossService championCrossService;
	@Autowired
	private MessageHelper messageHelper;
	
	@RequestMapping(value = "/cleanBiu", method = RequestMethod.GET)
	public String cleanBiubiubiu() {
		championCrossService.cleanBiu();
		//通知前端
		ResChampionCrossCleanBiuBuilder builder = ResChampionCrossCleanBiu.builder();
		messageHelper.pushToAll(builder.build());
		
		log.info("冠军赛清除弹幕");
		return GsonUtils.toJson(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
	}
}
