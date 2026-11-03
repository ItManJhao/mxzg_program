package com.ayjs.mxzg.gameserver.web.activity.config;

import lombok.Getter;
import lombok.Setter;

/**
 * 许愿池达标
 */
@Getter
@Setter
public class Promotion037WishTimesConfig implements IActivityConfig {

    @Override
    public int getId() {
        return idx;
    }

    private int idx;

    private int times;

    private String reward;
}
