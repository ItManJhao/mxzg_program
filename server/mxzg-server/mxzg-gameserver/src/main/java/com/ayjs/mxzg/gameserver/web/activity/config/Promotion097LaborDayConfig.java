package com.ayjs.mxzg.gameserver.web.activity.config;

import com.alibaba.fastjson.annotation.JSONField;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import lombok.Setter;

/**
 * @author Rondo
 * @Date 2021-04-14 17:30:45
 */
@Getter
@Setter
public class Promotion097LaborDayConfig implements IActivityConfig {

    private int idx;

    private int priority_status;

    private int star_server_day;

    private int end_server_day;

    private int round;

    private int position;

    private String reward;

    private int canAppear;

    private int weight;

    private int canChoice;

    @Override
    @JSONField(serialize = false)
    public int getId() {
        return idx;
    }

    @JSONField(serialize = false)
    private ImmutableList<ImmutableThing> rewardThings;

    @JSONField(serialize = false)
    public ImmutableList<ImmutableThing> getRewardThings() {
        if (rewardThings == null) {
            rewardThings = ImmutableThingUtil.fromJson(reward);
        }
        return rewardThings;
    }


}
