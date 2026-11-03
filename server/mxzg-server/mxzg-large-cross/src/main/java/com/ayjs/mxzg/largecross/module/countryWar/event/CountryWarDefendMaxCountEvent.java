package com.ayjs.mxzg.largecross.module.countryWar.event;

import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarRole;
import lombok.Value;

/**
 * 防守达到最大次数
 *
 * @Author: CWJ
 * @Date: 2021/4/26
 **/
@Value(staticConstructor = "of")
public class CountryWarDefendMaxCountEvent {
    private CountryWarRole defend;
}
