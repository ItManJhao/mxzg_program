package com.ayjs.mxzg.gameserver.web.api;

import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.gameserver.web.constant.WebErrorCode;
import com.ayjs.mxzg.gameserver.web.support.WebResult;
import com.ayjs.mxzg.template.hotupdate.HotUpdateService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/patch")
public class PatchApi {

	@Autowired
	private HotUpdateService hotUpdateService;

	/**
	 * 加载补丁
	 * @return
	 */
	@RequestMapping(value = "/loadpatch", method = RequestMethod.GET)
	public String loadPatch() {
		try {
			hotUpdateService.loadAgent();
			log.info("load patch success!");
			return GJsonUtils.toJson(WebResult.of(WebErrorCode.SUCCESS.getCode(), ""));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return GJsonUtils.toJson(WebResult.of(WebErrorCode.FAIL.getCode(), ""));
	}

}
