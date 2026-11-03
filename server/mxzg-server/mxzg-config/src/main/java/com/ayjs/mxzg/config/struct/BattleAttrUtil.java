package com.ayjs.mxzg.config.struct;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

/**
 * 战斗属性帮助类
 * 
 * @author meiyc
 *
 */
public class BattleAttrUtil {

	public static List<Attr> oldStrToAttr(String oldAttrStr) {
		JSONArray array = JSONArray.parseArray(oldAttrStr);
		List<Attr> attrList = new ArrayList<>(array.size());
		for (int i = 0; i < array.size(); i++) {
			JSONObject obj = array.getJSONObject(i);
			for (Map.Entry<String, Object> entry : obj.entrySet()) {
				Attr attr = new Attr();
				attr.setKey(Integer.parseInt(entry.getKey()));
				attr.setValue(Integer.parseInt(entry.getValue().toString()));
				attrList.add(attr);
			}
		}
		return attrList;
	}

}
