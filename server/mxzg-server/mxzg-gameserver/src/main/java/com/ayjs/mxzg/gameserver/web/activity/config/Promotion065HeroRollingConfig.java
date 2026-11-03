/**
 * 
 */
package com.ayjs.mxzg.gameserver.web.activity.config;

import java.util.ArrayList;
import java.util.List;

import com.alibaba.fastjson.annotation.JSONField;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;

import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 */
@Getter
@Setter
public class Promotion065HeroRollingConfig implements IActivityConfig {

	private int idx;
	private int task_count;
	private String box_reward;
	
	@JSONField(serialize = false)
    private ImmutableList<ImmutableThing> rewardThings;
    public ImmutableList<ImmutableThing> getRewardThings() {
        if (rewardThings == null) {
            rewardThings = ImmutableThingUtil.fromJson(box_reward);
        }
        return rewardThings;
    }

	@Override
	public int getId() {
		return idx;
	}
	
	public static void main(String[] args) {
		List<Promotion065HeroRollingConfig> list = new ArrayList<>();
		for(int i = 1; i <= 5; i++) {
			Promotion065HeroRollingConfig config = new Promotion065HeroRollingConfig();
			config.idx = 1;
			config.task_count = 30 * i;
			config.box_reward = "[{\"item_type\":20204000,\"item_num\":1}]";
			list.add(config);
		}
		System.out.println(JsonUtil.toJson(list));
	}
}
