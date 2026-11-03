package com.ayjs.mxzg.gameserver.web.activity.config;

import lombok.Getter;
import lombok.Setter;


@Getter
@Setter
public class Promotion038AstrologyConfig implements IActivityConfig {

    @Override
    public int getId() {
        return idx;
    }

    private int idx;

    private String need_hero;

    private String need_item;

    private String reward;

    private int show_hero;
}
