package com.ayjs.mxzg.gameserver.web.activity.config;

import com.alibaba.fastjson.annotation.JSONField;
import com.ayjs.mxzg.common.util.IDrop;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/9/23
 **/
@Getter
@Setter
public class Promotion094RandomRewardConfig implements IActivityConfig, IDrop {
    private int idx;

    private int weight;

    private String reward;

    private int priority_status;

    private int star_server_day;

    private int end_server_day;

    @Override
    @JSONField(serialize = false)
    public int getId() {
        return idx;
    }

    @Override
    @JSONField(serialize = false)
    public int getDropId() {
        return idx;
    }

    @Override
    @JSONField(serialize = false)
    public int getRate() {
        return weight;
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
