package com.ayjs.mxzg.gameserver.module.clergy.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.config.excel.cache.BuyGemSysCache;
import com.ayjs.mxzg.config.excel.cache.ClergyPrivilegeSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.struct.ClergyPrivilegeType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.event.ClergyExpAddEvent;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.dailydungeon.constant.DailyDungeonType;
import com.ayjs.mxzg.gameserver.module.recharge.domain.RoleRecharge;
import com.ayjs.mxzg.gameserver.module.recharge.event.RechargeEvent;
import com.ayjs.mxzg.gameserver.module.recharge.service.RoleRechargeService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.ClergyGMsg;
import com.google.common.collect.ImmutableList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * 神职
 *
 * @author hyc
 */
@Service
@Observer
public class ClergyService {

    @Autowired
    private RoleService roleService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private ClergyPrivilegeSysCache clergyPrivilegeSysCache;
    @Autowired
    private BuyGemSysCache buyGemSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private RoleRechargeService roleRechargeService;

    private final static int CHANCE = 10000;

    @Subscribe
    private void listen(ClergyExpAddEvent event) {
        ClergyGMsg.GResClergyExpChange.Builder builder = ClergyGMsg.GResClergyExpChange.newBuilder();
        builder.setClergyExp(event.getCurr());
        contextManager.write(event.getRid(), CmdCode._46002, builder.build());
    }

    @Subscribe
    private void listen(RechargeEvent event) {
        ImmutableList<ImmutableThing> reward = null;
        if (event.getProductId() <= 0) {
            // 第三方充值直接用购买金币数量乘以10当成神职经验
            reward = ImmutableList.of(ImmutableThing.of(ItemType.IT_CLERGY_EXP, event.getGameCoin() * 10));
        } else {
            CBuyGem cBuyGem = buyGemSysCache.getOrThrow(event.getProductId());
            reward = cBuyGem.getClergy_gain();
        }
        if (reward != null && ImmutableThingUtil.getAllItemNums(reward) > 0) {
            thingService.add(event.getRid(), reward, GameEvent.RECHARGE, NoticeType.SLIENT);
        }
    }

    /**
     * 副本加成
     *
     * @param dailyDungeonType
     * @param rewards
     */
    public List<ImmutableThing> dungeonPrivilege(long rid, DailyDungeonType dailyDungeonType, List<ImmutableThing> rewards) {

        List<ImmutableThing> rewardList = new ArrayList<>();
        ClergyPrivilegeType clergyPrivilegeType = this.privilegeType(dailyDungeonType);

        if (clergyPrivilegeType != null) {
            Role role = roleService.getOrThrow(rid);
            rewardList = this.clergyEarnings(role, clergyPrivilegeType, rewards);
        }
        return rewardList;
    }

    /**
     * 神职收益加成
     *
     * @param role
     * @param clergyPrivilegeType 神职
     * @param rewards             基础资源
     * @return 只返回加成收益，不含基础资源。
     */
    public List<ImmutableThing> clergyEarnings(Role role, ClergyPrivilegeType clergyPrivilegeType, List<ImmutableThing> rewards) {

        List<ImmutableThing> rewardList = new ArrayList<>();

        clergyPrivilegeSysCache.getAll().stream().filter(cClergyPrivilege -> cClergyPrivilege.getUnlock_privilege() != null &&
                role.getClergyLevel() >= cClergyPrivilege.getClergy_level() && cClergyPrivilege.getUnlock_privilege().getType() == clergyPrivilegeType
                && RandomUtil.rand(1, CHANCE + 1) <= cClergyPrivilege.getUnlock_privilege().getChance()).forEach(cClergyPrivilege -> {

            List<ImmutableThing> list = ImmutableThingUtil.multiplyThing(rewards, (float) cClergyPrivilege.getUnlock_privilege().getValue() / CHANCE);
            rewardList.addAll(list);

        });
        return rewardList;
    }


    private ClergyPrivilegeType privilegeType(DailyDungeonType dailyDungeonType) {

        if (dailyDungeonType == DailyDungeonType.GOLD_DUNGEON) {
            return ClergyPrivilegeType.GOLD_DUNGEON;
        } else if (dailyDungeonType == DailyDungeonType.EXP_DUNGEON) {
            return ClergyPrivilegeType.EXP_DUNGEON;
        } else if (dailyDungeonType == DailyDungeonType.HERO_DUNGEON) {
            return ClergyPrivilegeType.HERO_DUNGEON;
        } else if (dailyDungeonType == DailyDungeonType.FETTER_DUNGEON) {
            return ClergyPrivilegeType.FETTER_DUNGEON;
        } else if (dailyDungeonType == DailyDungeonType.RUNE_DUNGEON) {
            return ClergyPrivilegeType.RUNE_DUNGEON;
        }
        return null;
    }

}
