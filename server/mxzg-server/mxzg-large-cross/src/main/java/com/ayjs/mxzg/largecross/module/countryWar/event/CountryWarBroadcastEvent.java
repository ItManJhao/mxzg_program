package com.ayjs.mxzg.largecross.module.countryWar.event;

import lombok.Value;

import java.util.List;

/**
 * 防守达到最大次数
 *
 * @Author: CWJ
 * @Date: 2021/4/26
 **/
@Value(staticConstructor = "of")
public class CountryWarBroadcastEvent {
    private int groupId;
    private List<Integer> cityIds;
}
