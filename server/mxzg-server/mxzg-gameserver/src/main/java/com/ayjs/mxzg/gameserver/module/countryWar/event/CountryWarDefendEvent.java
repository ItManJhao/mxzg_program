package com.ayjs.mxzg.gameserver.module.countryWar.event;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2021/4/26
 **/
@Value(staticConstructor = "of")
public class CountryWarDefendEvent {
    private long rid;
    //攻击成功
    private boolean defendSuccess;
}
