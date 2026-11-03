package com.ayjs.mxzg.largecross.module.countryWar.struct;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @Author: CWJ
 * @Date: 2021/4/26
 **/
@Getter
@Setter
public class CountryWarGroup {
    //组id
    private int groupId;
    //服务器id
    private List<Integer> serverIds = new ArrayList<>();
    //城池数据
    private Map<Integer, CountryWarCity> cityMap = new ConcurrentHashMap<>();
    private CountryWarCityEvent event = new CountryWarCityEvent();
    //商店所在城池
    private int shopCityId;


    /***
     * 最强服务器id
     */
    private int strongestId;
    //商店刷新时间
//    private LocalDate shopRefreshData = LocalDate.of(1970, 1, 1);

    public void resetEvent(int cityId, int eventId) {
        event.reset();
        event.setNewEvent(cityId, eventId);
    }

    public void resetShop(int cityId) {
        shopCityId = cityId;
    }

    public CountryWarCity getCity(int cityId) {
        return cityMap.get(cityId);
    }

}
