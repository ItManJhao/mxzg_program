package com.ayjs.mxzg.gameserver.web.activity.config;

import com.alibaba.fastjson.annotation.JSONField;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Promotion068SpacetimeTreasureConfig implements IActivityConfig {

    private int idx;

    private int priority_status;

    private int star_server_day;

    private int end_server_day;

    private int day;

    private String reward;

    @Override
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
