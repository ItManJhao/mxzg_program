package com.ayjs.mxzg.gameserver.web.activity.config;

import lombok.Getter;
import lombok.Setter;

/**
 * 赏月佳肴
 */
@Getter
@Setter
public class Promotion081GiftConfig implements IActivityConfig {
    private int idx;

    private int priority_status;

    private int star_server_day;

    private int end_server_day;

    private int product_id;

    private int discount_rate;

    private int discount_product_id;

    private int complete_discount_rate;

    private String reward;

    private int need_count;

    private int buy_limit;

    private int gift_name;

    @Override
    public int getId() {
        return idx;
    }
}
