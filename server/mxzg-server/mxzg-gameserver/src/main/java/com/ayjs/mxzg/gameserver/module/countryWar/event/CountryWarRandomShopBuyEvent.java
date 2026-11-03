package com.ayjs.mxzg.gameserver.module.countryWar.event;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2021/4/26
 **/
@Value(staticConstructor = "of")
public class CountryWarRandomShopBuyEvent {
    private long rid;
    //购买数量
    private int count;
}
