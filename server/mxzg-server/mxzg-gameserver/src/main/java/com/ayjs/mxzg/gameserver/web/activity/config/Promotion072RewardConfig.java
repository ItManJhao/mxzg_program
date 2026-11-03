package com.ayjs.mxzg.gameserver.web.activity.config;

import com.alibaba.fastjson.annotation.JSONField;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import lombok.Setter;

/**
 * 诸神祭坛奖励表
 */
@Getter
@Setter
public class Promotion072RewardConfig implements IActivityConfig {
    private int idx;
    private int weight;//权重
    private String reward;//奖励
    private int floor;//层数
    private int star_server_day;
    private int priority_status;
    private int end_server_day;

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
