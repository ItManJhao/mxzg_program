package com.ayjs.mxzg.gameserver.web.activity.config;

import com.alibaba.fastjson.annotation.JSONField;
import lombok.Getter;
import lombok.Setter;

/**
 * @author Rondo
 * 2021-07-05 12:00:00
 */
@Getter
@Setter
public class Promotion098ActiveJumpConfig implements IActivityConfig{
    private int idx;

    private int priority_status;

    private int star_server_day;

    private int end_server_day;

    private int state;
    // 渠道id
    private String canal;
    //跳转的url
    private String url;

    @Override
    @JSONField(serialize = false)
    public int getId() {
        return idx;
    }
}
