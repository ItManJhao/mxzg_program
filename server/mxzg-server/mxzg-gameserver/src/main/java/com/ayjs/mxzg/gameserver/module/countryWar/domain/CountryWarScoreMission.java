package com.ayjs.mxzg.gameserver.module.countryWar.domain;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2021/4/24
 **/
@Setter
@Getter
public class CountryWarScoreMission {
    private int type;
    private int round;
    private Map<Integer, Long> missionCount = new HashMap<>();
    private Map<Integer, Boolean> missionReward = new HashMap<>();
    private LocalDate refreshDate;
    private LocalDate loginDate;

    public void addCount(int id, long add) {
        missionCount.put(id, missionCount.getOrDefault(id, 0l) + add);
    }

    public void setCount(int id, long setValue) {
        missionCount.put(id, setValue);
    }

    public long getCount(int id) {
        return missionCount.getOrDefault(id, 0l);
    }
}
