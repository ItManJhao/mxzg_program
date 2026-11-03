/**
 * 
 */
package com.ayjs.mxzg.gameserver.web.util;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;

import cn.hutool.crypto.digest.MD5;

/**
 * @author YY
 *
 */
@Component
public class ApiUtil {

	@Autowired
	private ServerConfig serverConfig;
	
	/**
	 * 构建签名
	 * @param signMap
	 * @return
	 */
	public String buildSignStr(Map<String, String> signMap) {
		List<String> keyList = new ArrayList<>(signMap.keySet());
		Collections.sort(keyList);
		StringBuilder builder = new StringBuilder();
		for(String key : keyList) {
			builder.append(signMap.get(key));
		}
		builder.append(serverConfig.getPlatformKey());
		return builder.toString();
	}
	
	public String buildSign(String str) {
		return MD5.create().digestHex(str).toLowerCase();
	}
	
	public static void main(String[] args) {
		System.out.println(MD5.create().digestHex("recharge.chargeCallback0110110000000081915753798011^-^ayjsgame!@#api&201912").toLowerCase());
	}
	
	public void testSign() {
		Map<String, String> signMap = new HashMap<>();
		signMap.put("action", "Recharge.chargeCallback");
		signMap.put("orderId", "111111111");
		signMap.put("money", "64800");
		signMap.put("status", "1");
		signMap.put("isTest", "0");
		signMap.put("payTime", "6592546856");
		String localSign = buildSignStr(signMap);
		System.out.println(localSign);
		
		//8a0d85695fa7347bef2f5d2404cd7815
		//8a0d85695fa7347bef2f5d2404cd7815
	}
}
