package com.ayjs.mxzg.gameserver.web.activity.config;


import lombok.Getter;
import lombok.Setter;

/**
 * 节日登陆有礼
 * @author hyx
 *
 */
@Getter
@Setter
public class Promotion051FestivalLoginGiftConfig implements IActivityConfig {

    private int idx;

    private int day;

    private String item;

    private int lan;

    @Override
    public int getId() {
        return day;
    }
}
