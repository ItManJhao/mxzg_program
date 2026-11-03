package com.ayjs.mxzg.gameserver.web.activity.config;

import lombok.Getter;
import lombok.Setter;

/**
 * 节日豪礼
 * @author hyx
 */
@Getter
@Setter
public class Promotion050FestivalOvervalueGiftConfig implements IActivityConfig {

    private int idx;

    private int grid_type;

    private int production_id;

    private String gift_reward;

    @Override
    public int getId() {
        return idx;
    }
}
