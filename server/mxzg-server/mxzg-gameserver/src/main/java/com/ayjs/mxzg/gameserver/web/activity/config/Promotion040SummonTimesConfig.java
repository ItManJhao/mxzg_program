package com.ayjs.mxzg.gameserver.web.activity.config;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Promotion040SummonTimesConfig implements IActivityConfig {

    private int idx;

    private int summon_times;

    private String reward;

    @Override
    public int getId() {
        return idx;
    }
}
