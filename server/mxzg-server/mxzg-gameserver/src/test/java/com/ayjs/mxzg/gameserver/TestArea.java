package com.ayjs.mxzg.gameserver;

import com.ayjs.mxzg.gameserver.module.recharge.constant.RechargeLimitArea;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;

import java.util.HashSet;
import java.util.Set;

@Slf4j
public class TestArea {
    public static void main(String[] args) {
        Set<String> areas = new HashSet<>();
        areas.add("海南省");
        areas.add("湖南省");
        areas.add("广州市");


        System.out.println(isContainsArea(areas, "广东省", "广州市"));
        System.out.println(isContainsArea(areas, "广东省", "深圳市"));
        System.out.println(isContainsArea(areas, "广东省", "惠州市"));
        System.out.println(isContainsArea(areas, "湖南省", "衡阳市"));
        System.out.println(isContainsArea(areas, "湖北省", "武汉市"));
    }

    public static boolean isContainsArea(Set<String> areas, String province, String cityName) {
        log.debug("areas:{}, province:{} cityName:{}", areas, province, cityName);
        if (CollectionUtils.isEmpty(areas) || StringUtils.isBlank(province) || StringUtils.isBlank(cityName)) {
            log.debug("1");
            return false;
        }
        if (areas.contains(cityName) && RechargeLimitArea.limitAreas.contains(cityName)) {
            log.debug("2");
            return true;
        }
        if (areas.contains(province) && !RechargeLimitArea.limitAreas.contains(cityName)) {
            log.debug("3");
            return true;
        }

        if (areas.contains(cityName)) {
            log.debug("4");
            return true;
        }
        log.debug("5");
        return false;
    }
}
