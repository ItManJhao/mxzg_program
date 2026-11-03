package com.ayjs.mxzg.gameserver.web.activity.config;


import lombok.Getter;
import lombok.Setter;

/**
 * 高级周卡
 *
 * @author hyx
 */
@Getter
@Setter
public class Promotion058HighWeeksCardConfig implements IActivityConfig  {

    private int idx;

    private int priority_status;

    private int star_server_day;

    private int end_server_day;

    private int product_id;

    private String reward;

    private int buy_limit;

    private String hero_name;

    @Override
    public int getId() {
        return idx;
    }
}
