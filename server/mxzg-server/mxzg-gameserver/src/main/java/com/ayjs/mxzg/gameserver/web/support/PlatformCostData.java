package com.ayjs.mxzg.gameserver.web.support;

import com.ayjs.mxzg.common.util.JsonUtil;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/5/12
 **/
@Getter
@Setter
public class PlatformCostData {
    private long rid;
    private Map<Integer, Long> cost;

    public static void main(String[] args) {
        PlatformCostData data = new PlatformCostData();
        data.setRid(1005000009);
        Map map = new HashMap();
        map.put(900601, 10);
        map.put(900801, 10);
        data.setCost(map);
        System.out.println(JsonUtil.toJson(data));
    }
}
