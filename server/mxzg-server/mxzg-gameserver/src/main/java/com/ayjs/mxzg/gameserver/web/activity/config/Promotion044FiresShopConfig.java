package com.ayjs.mxzg.gameserver.web.activity.config;

import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2019/10/26
 **/
@Getter
@Setter
public class Promotion044FiresShopConfig implements IActivityConfig {
    private int idx;
    private String item;
    private String cost;
    private int limit;
    private int mark_icon;
    private int show_mark;

    @Override
    public int getId() {
        return idx;
    }
}
