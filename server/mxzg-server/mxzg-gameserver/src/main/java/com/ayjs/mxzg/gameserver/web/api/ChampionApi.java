/**
 * 
 */
package com.ayjs.mxzg.gameserver.web.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.alibaba.fastjson.JSON;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.champion.service.ChampionService;
import com.ayjs.mxzg.gameserver.web.constant.WebErrorCode;
import com.ayjs.mxzg.gameserver.web.support.WebResult;
import com.ayjs.mxzg.protocol.ChampionGMsg.GResChampionCleanBiu;

import lombok.extern.slf4j.Slf4j;

/**
 * @author YY
 *
 */
@Slf4j
@RestController
@RequestMapping("/champion")
public class ChampionApi {

	@Autowired
	private ChampionService championService;
	@Autowired
	private ContextManager contextManager;
	
	@RequestMapping(value = "/cleanBiu", method = RequestMethod.GET)
	public String cleanBiubiubiu() {
		championService.cleanBiu();
		contextManager.writeAll(CmdCode._41022, GResChampionCleanBiu.getDefaultInstance());
		log.info("冠军赛清除弹幕");
		return JSON.toJSONString(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
	}
	
	
}
