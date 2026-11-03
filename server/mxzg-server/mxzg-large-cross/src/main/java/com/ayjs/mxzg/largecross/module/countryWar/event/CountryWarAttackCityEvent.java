package com.ayjs.mxzg.largecross.module.countryWar.event;

import lombok.Value;

/**
 * 攻城事件,有防守方才抛出
 *
 * @Author: CWJ
 * @Date: 2021/4/13
 **/
@Value(staticConstructor = "of")
public class CountryWarAttackCityEvent {
    private int groupId;
    private long rid;
    private boolean win;
}
