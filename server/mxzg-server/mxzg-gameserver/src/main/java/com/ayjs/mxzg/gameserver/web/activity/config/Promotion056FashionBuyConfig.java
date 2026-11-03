package com.ayjs.mxzg.gameserver.web.activity.config;

import lombok.Getter;
import lombok.Setter;

/**
 * 皮肤购买
 *
 * @author hyx
 */
@Getter
@Setter
public class Promotion056FashionBuyConfig implements IActivityConfig {

    private int idx;

    private int production_id;

    /**
     * 当状态为1时，优先级最高。所有服务器读同一条配置。
     */
    private int priority_status;

    private int star_server_day;

    private int end_server_day;

    private int num;

    private String reward;

    private int fashion_id;

    private String ability;

    private String name_buy;

    private String name_buy_gray;

    private String hero_name;


    @Override
    public int getId() {
        return idx;
    }

}
