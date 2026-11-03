package com.ayjs.mxzg.config.excel.cache;

import cn.hutool.core.lang.WeightRandom;
import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.config.excel.entity.CDropGroup;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;


/**
 * 掉落组
 */
@Component
public class DropGroupSysCache extends BaseExcelCache<CDropGroup> {

    private Map<Integer, WeightRandom<CDropGroup>> groupMap = new HashMap<>();

    @Override
    public String getFileName() {
        return "dropgroup";
    }

    @Override
    protected void loadAfterReady() {
        Map<Integer, WeightRandom<CDropGroup>> groupMap_ = new HashMap<>();
        getAll().stream().forEach(cDropGroup -> {
            WeightRandom<CDropGroup> groupList = groupMap_.computeIfAbsent(cDropGroup.getDrop_trigger_id(),
                    k -> WeightRandom.create());
            groupList.add(cDropGroup, cDropGroup.getChance());
        });
        groupMap = groupMap_;
    }

    public ImmutableThing getDropThing(int dropTriggerId) {

        WeightRandom<CDropGroup> groupWeightRandom = groupMap.get(dropTriggerId);
        ConfigAsserts.notNull(groupWeightRandom,
                () -> String.format("CDropGroup is null or empty dropTriggerId:%s", dropTriggerId));
        CDropGroup dropGroup = groupWeightRandom.next();

        return ImmutableThing.of(dropGroup.getItem_type(),
                RandomUtil.rand(dropGroup.getItem_min(), dropGroup.getItem_max() + 1));
    }
}
