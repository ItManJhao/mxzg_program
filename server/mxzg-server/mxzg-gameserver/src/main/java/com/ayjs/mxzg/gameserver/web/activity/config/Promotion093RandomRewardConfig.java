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
 * @Date: 2021/2/25
 **/
@Getter
@Setter
public class Promotion093RandomRewardConfig implements IActivityConfig, IDrop {

    private int idx;
    private int type;
    private int weight;
    private String reward;

    private int priority_status;
    private int star_server_day;
    private int end_server_day;


    @JSONField(serialize = false)
    private ImmutableList<ImmutableThing> rewardThing;

    public ImmutableList<ImmutableThing> getRewardThing() {
        if (rewardThing == null) {
            rewardThing = ImmutableThingUtil.fromJson(reward);
        }
        return rewardThing;
    }

    @JSONField(serialize = false)
    @Override
    public int getDropId() {
        return idx;
    }

    @JSONField(serialize = false)
    @Override
    public int getRate() {
        return weight;
    }

    @Override
    public int getId() {
        return idx;
    }
}
