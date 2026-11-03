package com.ayjs.mxzg.gameserver.web.activity.config;

import com.alibaba.fastjson.annotation.JSONField;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import lombok.Setter;

/**
 * 运营累充活动
 *
 * @Author: CWJ
 * @Date: 2019/10/22
 **/
@Setter
@Getter
public class Promotion096BoxRewardConfig implements IActivityConfig {
    private int idx;
    private int count;
    private String reward;
    private int priority_status;

    private int star_server_day;

    private int end_server_day;

    @Override
    @JSONField(serialize = false)
    public int getId() {
        return idx;
    }

    @JSONField(serialize = false)
    private ImmutableList<ImmutableThing> rewardThings;

    public ImmutableList<ImmutableThing> getRewardThings() {
        if (rewardThings == null) {
            rewardThings = ImmutableThingUtil.fromJson(reward);
        }
        return rewardThings;
    }
}
