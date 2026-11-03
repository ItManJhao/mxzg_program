package com.ayjs.mxzg.largecross.module.countryWar.struct;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * @Author: CWJ
 * @Date: 2021/4/19
 **/
@Getter
@Setter
public class CountryWarCityEvent {
    private int cityId;
    private int eventId;
    private LocalDateTime rewardTime;

    public void reset() {
        cityId = 0;
        eventId = 0;
        rewardTime = LocalDateTime.now();
    }

    public void setNewEvent(int cityId, int eventId) {
        this.cityId = cityId;
        this.eventId = eventId;
        rewardTime = LocalDateTime.now();
    }
}
