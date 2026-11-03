package com.ayjs.mxzg.gameserver.web.activity.config;

import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2019/10/26
 **/
@Setter
@Getter
public class Promotion045LoginGiftConfig implements IActivityConfig {
    private int idx;
    private int need_login_day;
    private String reward;

    @Override
    public int getId() {
        return idx;
    }
}
