package com.ayjs.mxzg.gameserver.web.activity.config;


import lombok.Getter;
import lombok.Setter;


/**
 * 告知馈赠活动配置表
 */
@Getter
@Setter
public class Promotion041ProphecyTimesConfig implements IActivityConfig {

    private int idx;

    private int play_times;

    private String reward;

    @Override
    public int getId() {
        return idx;
    }
}
