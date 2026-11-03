package com.ayjs.mxzg.gameserver.web.activity.config;

import com.alibaba.fastjson.annotation.JSONField;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;
import com.google.common.reflect.TypeToken;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2021/2/25
 **/
@Getter
@Setter
public class Promotion092Config implements IActivityConfig {

    private int idx;
    private String deliver_cost;
    private int score;
    private int hero_rank_reward;
    private int need_count;
    private String select_hero;
    private int priority_status;

    private int star_server_day;

    private int end_server_day;

    @JSONField(serialize = false)
    private ImmutableList<ImmutableThing> deliverCostThings;

    public ImmutableList<ImmutableThing> getDeliverCostThings() {
        if (deliverCostThings == null) {
            deliverCostThings = ImmutableThingUtil.fromJson(deliver_cost);
        }
        return deliverCostThings;
    }

    @JSONField(serialize = false)
    private ImmutableList<Integer> selectHeroes;

    public ImmutableList<Integer> getSelectHeroes() {
        if (selectHeroes == null) {
            selectHeroes = GsonUtils.fromJson(select_hero, new TypeToken<ImmutableList<Integer>>() {
            });
        }
        return selectHeroes;
    }

    @Override
    public int getId() {
        return idx;
    }
}
