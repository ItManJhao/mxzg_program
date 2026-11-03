package com.ayjs.mxzg.config.excel.cache;

import cn.hutool.core.lang.WeightRandom;
import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CRewardGroup;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

/**
 * 奖励组表
 */
@Component
public class RewardGroupSysCache extends BaseExcelCache<CRewardGroup> {

    private Map<Integer, WeightRandom<CRewardGroup>> groupMap = new HashMap<>();

    @Override
    public String getFileName() {
        return "rewardgroup";
    }

    @Override
    protected void loadAfterReady() {
        Map<Integer, WeightRandom<CRewardGroup>> groupMapTemp = new HashMap<>();
        getAll().stream().forEach(cRewardGroup -> {
            WeightRandom<CRewardGroup> groupList = groupMapTemp.computeIfAbsent(cRewardGroup.getGroup_id(),
                    k -> WeightRandom.create());
            groupList.add(cRewardGroup, cRewardGroup.getWeight());
        });
        groupMap = groupMapTemp;
    }

    /**
     * 按照权重得到一个奖励组的奖励
     *
     * @param groupId
     * @return
     */
    public ImmutableList<ImmutableThing> getRewardGroupThing(int groupId) {
        WeightRandom<CRewardGroup> rewardGroup = groupMap.get(groupId);
        ConfigAsserts.notNull(rewardGroup, () -> String.format("CRewardGroup is null or empty groupId:%s", groupId));
        CRewardGroup rewardGroupItem = rewardGroup.next();
        return rewardGroupItem.getItem();
    }
}
