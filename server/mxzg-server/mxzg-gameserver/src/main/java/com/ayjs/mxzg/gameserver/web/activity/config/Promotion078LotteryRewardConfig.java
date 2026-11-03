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
public class Promotion078LotteryRewardConfig implements IActivityConfig, IDrop {
    private int idx;

    private int weight;

    private int type;

    private String show_reward;

    private String reward;

    /**
     * 多少次后才出
     */
    private int min_count;
    /**
     * 多少次内必出
     */
    private int max_count;

    /***
     * 是否需要选择
     */
    private int need_select;

    private String show_hero_reward;

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
