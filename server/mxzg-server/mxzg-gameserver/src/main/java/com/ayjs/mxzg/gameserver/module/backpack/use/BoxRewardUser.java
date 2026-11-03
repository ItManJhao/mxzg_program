package com.ayjs.mxzg.gameserver.module.backpack.use;

import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.config.excel.cache.ItemBoxChanceSysCache;
import com.ayjs.mxzg.config.excel.entity.CItem;
import com.ayjs.mxzg.config.excel.entity.CItemBoxChance;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class BoxRewardUser implements ThingUse {

    @Autowired
    private ThingService thingService;
    @Autowired
    private ItemBoxChanceSysCache itemBoxChanceSysCache;
    @Autowired
    private RoleService roleService;

    @Override
    public ThingUseType getType() {
        return ThingUseType.BOX_REWARD;
    }

    @Override
    public Rewards use(long rid, CItem cItem, int num, GameEvent event) {
        CItemBoxChance cItemBoxChance = itemBoxChanceSysCache.getOrThrow(cItem.getUse_value());

        Role role = roleService.getOrThrow(rid);

        ImmutableThing cost = ImmutableThing.of(cItem.getIdx(), num, 0);

        List<ImmutableThing> result = new ArrayList<>();
        for (int i = 0; i < num; i++) {
            List<ImmutableThing> reward = cItemBoxChance.getItem();
            if (cItemBoxChance.getKind() == 1) {//全出
                result.addAll(reward);
            } else {//抽取一
                ImmutableThing randomReward = DropUtil.randomDrop(reward);
                if (randomReward != null) {
                    result.add(randomReward);
                }
            }
        }

        Asserts.isTrue(!result.isEmpty(), ErrorCode.CONFIG_DATA_ERROR.getValue(),
                () -> "randomReward is null:" + cItem.getIdx());

        thingService.cost(role.getId(), cost, event);

        result = ImmutableThingUtil.mergeThing(result);

        return thingService.add(role.getId(), result, event, NoticeType.SLIENT);
    }
}
