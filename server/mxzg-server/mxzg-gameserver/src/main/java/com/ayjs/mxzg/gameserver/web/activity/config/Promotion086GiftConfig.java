package com.ayjs.mxzg.gameserver.web.activity.config;

import com.alibaba.fastjson.annotation.JSONField;
import lombok.Getter;
import lombok.Setter;

/**
 * 赏月佳肴
 */
@Getter
@Setter
public class Promotion086GiftConfig implements IActivityConfig {
    private int idx;

    private int priority_status;

    private int star_server_day;

    private int end_server_day;

    private int product_id;

    private String reward;

    private int buy_limit;

    private int gift_name;

    private String hero_name;

    @Override
    @JSONField(serialize = false)
    public int getId() {
        return idx;
    }
}
