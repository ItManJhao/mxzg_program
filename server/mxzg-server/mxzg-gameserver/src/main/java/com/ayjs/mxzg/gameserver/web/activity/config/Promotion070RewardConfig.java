package com.ayjs.mxzg.gameserver.web.activity.config;

import com.alibaba.fastjson.annotation.JSONField;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/8/10
 **/
@Getter
@Setter
public class Promotion070RewardConfig implements IActivityConfig {

    private int idx;
    private String reward;
    private int weight;
    private int type;

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
