package com.ayjs.mxzg.gameserver.web.activity.config;

import com.alibaba.fastjson.annotation.JSONField;
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
public class Promotion076ExchangeRewardConfig implements IActivityConfig {
    private int idx;

    private String need_item;

    private String reward;

    /***
     * 1.普通兑换
     * 2.普通兑换激活永久后，可以兑换
     */
    private int type;

    /***
     * 关联皮肤id
     */
    private int fashion_id;

    @JSONField(serialize = false)
    private ImmutableList<ImmutableThing> needItemThings;

    @JSONField(serialize = false)
    private ImmutableList<ImmutableThing> rewardThings;

    public ImmutableList<ImmutableThing> getRewardThings() {
        if (rewardThings == null) {
            rewardThings = ImmutableThingUtil.fromJson(reward);
        }
        return rewardThings;
    }

    public ImmutableList<ImmutableThing> getNeedItemThings() {
        if (needItemThings == null) {
            needItemThings = ImmutableThingUtil.fromJson(need_item);
        }
        return needItemThings;
    }

    @Override
    public int getId() {
        return idx;
    }

}
