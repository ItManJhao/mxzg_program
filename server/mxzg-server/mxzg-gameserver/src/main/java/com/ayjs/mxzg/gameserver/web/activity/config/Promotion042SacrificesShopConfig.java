package com.ayjs.mxzg.gameserver.web.activity.config;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Promotion042SacrificesShopConfig implements IActivityConfig {

    public int idx;

    public int chance;

    public String item_type;

    public String need_item;

    public int buy_limit;

    @Override
    public int getId() {
        return idx;
    }
}
