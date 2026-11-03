package com.ayjs.mxzg.gameserver.web.activity.config;

import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2019/10/26
 **/

@Getter
@Setter
public class Promotion046ExchangeShopConfig implements IActivityConfig {
    @Override
    public int getId() {
        return idx;
    }

    private int idx;
    private String need_item;
    private String reward;
    private int limit;
    private int show_red_dot;

}
