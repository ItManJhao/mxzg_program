package com.ayjs.mxzg.gameserver.web.activity.config;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Promotion039OvervalueGiftConfig implements IActivityConfig {

    private int idx;

    private int production_id;

    private String gift_reward;

    private int buy_limit;

    @Override
    public int getId() {
        return idx;
    }
}
