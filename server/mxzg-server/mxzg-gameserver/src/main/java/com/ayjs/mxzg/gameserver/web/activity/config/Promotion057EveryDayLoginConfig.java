package com.ayjs.mxzg.gameserver.web.activity.config;

import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.config.struct.TargetStruct;
import lombok.Getter;
import lombok.Setter;

/**
 * 指日登陆活动配置
 *
 * @author hyx
 */
@Getter
@Setter
public class Promotion057EveryDayLoginConfig implements IActivityConfig {

    private int idx;

    private int priority_status;

    private int star_server_day;

    private int end_server_day;

    private int turns;

    private String task;

    private String reward;

    private String jump_info;

    private int lang;

    public TargetStruct getTargetStruct() {
        return JsonUtil.parseJson(task, TargetStruct.class);
    }

    @Override
    public int getId() {
        return idx;
    }

}
