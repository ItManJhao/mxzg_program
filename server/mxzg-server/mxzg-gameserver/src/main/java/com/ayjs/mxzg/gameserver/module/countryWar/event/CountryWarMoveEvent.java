package com.ayjs.mxzg.gameserver.module.countryWar.event;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2021/4/26
 **/
@Value(staticConstructor = "of")
public class CountryWarMoveEvent {
    private long rid;
    //是否消耗
    private boolean cost;
}
