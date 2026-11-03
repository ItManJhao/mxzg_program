package com.ayjs.mxzg.largecross.module.countryWar.event;

import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarRole;
import lombok.Value;

/**
 * 城池服务器归属切换
 *
 * @Author: CWJ
 * @Date: 2021/4/13
 **/
@Value(staticConstructor = "of")
public class CountryWarCityChangeServerEvent {
    private int groupId;
    private int idx;
    private CountryWarRole attack;
    private CountryWarRole defend;
    private boolean firstOccupy;
}
