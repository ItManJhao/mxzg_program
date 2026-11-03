/**
 *
 */
package com.ayjs.mxzg.gameserver.module.battle.service;

import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.ChapterrewardSysCache;
import com.ayjs.mxzg.config.excel.cache.DropGroupSysCache;
import com.ayjs.mxzg.config.excel.cache.DropTriggerSysCache;
import com.ayjs.mxzg.config.excel.cache.GoddessVipSysCache;
import com.ayjs.mxzg.config.excel.cache.WorldLevelGainExpSysCache;
import com.ayjs.mxzg.config.excel.constant.IdleConst;
import com.ayjs.mxzg.config.excel.entity.CChapterreward;
import com.ayjs.mxzg.config.excel.entity.CDropTrigger;
import com.ayjs.mxzg.config.excel.entity.CGoddessVip;
import com.ayjs.mxzg.config.excel.entity.CWorldLevelGainExp;
import com.ayjs.mxzg.config.struct.ClergyPrivilegeType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.ThingBonus;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.dao.RoleMissionDao;
import com.ayjs.mxzg.gameserver.module.battle.domain.DropData;
import com.ayjs.mxzg.gameserver.module.battle.domain.RoleMission;
import com.ayjs.mxzg.gameserver.module.clergy.service.ClergyService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PrivilegeEffectType;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion010PrivilegeGiftService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion016DragonInfoService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion034ZhuShenService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion044FiresShopService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleVipService;
import com.ayjs.mxzg.gameserver.module.worldLevel.manager.WorldLevelManager;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.ayjs.mxzg.template.constant.GameConstant;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * @author YY
 *
 */
@Slf4j
@Service
public class RoleMissionService {

    @Autowired
    private RoleMissionDao roleMissionDao;
    @Autowired
    private RoleService roleService;
    @Autowired
    private RoleVipService roleVipService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private DropTriggerSysCache dropTriggerSysCache;
    @Autowired
    private DropGroupSysCache dropGroupSysCache;
    @Autowired
    private ChapterrewardSysCache chapterrewardSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private GoddessVipSysCache goddessVipSysCache;
    @Autowired
    private Promotion016DragonInfoService promotion016DragonInfoService;
    @Autowired
    private Promotion034ZhuShenService promotion034ZhuShenService;
    @Autowired
    private Promotion044FiresShopService promotion044FiresShopService;
    @Autowired
    private Promotion010PrivilegeGiftService promotion010PrivilegeGiftService;
    @Autowired
    private ClergyService clergyService;
    @Autowired
    private WorldLevelGainExpSysCache worldLevelGainExpSysCache;
    @Autowired
    private WorldLevelManager worldLevelService;


    public RoleMission getRoleMission(long rid) {
        RoleMission roleMission = roleMissionDao.get(rid);
        int now = DateTimeUtil.currentSecond();
        if (roleMission == null) {
            roleMission = new RoleMission();
            roleMission.setRid(rid);
            roleMission.setChapterReward(new ArrayList<>());
            roleMission.setChapterRewardId(new ArrayList<>());
            roleMission.setStartTime(now - IdleConst.INITIAL_TIME);
            roleMission.setQuickBattleTime(now);
            roleMission.setQuickNum(0);
            roleMission.setDropData(new HashMap<>());
            roleMission.setDropRewardTime(0);
            roleMissionDao.add(roleMission);
        }
        boolean needUpdate = false;
        if (roleMission.getQuickBattleTime() < DateTimeUtil.dayBreak()) {
            roleMission.setQuickNum(0);
            needUpdate = true;
        }
        if (needUpdate) {
            this.updateRoleMission(roleMission);
        }
        return roleMission;
    }

    public void updateRoleMission(RoleMission roleMission) {
        roleMissionDao.update(roleMission);
    }

    public List<RoleMission> getAllRoleMission() {
        return roleMissionDao.listAll();
    }

    /**
     * GM命令测试掉落
     *
     * @param rid
     * @param missionId     关卡id
     * @param onceDropTimes 单词掉落次数
     * @param totalTimes    总掉落回合
     * @param refreshLimit  多少回合重置一次
     */
    public void gmTestIdleAward(long rid, int missionId, int onceDropTimes, int totalTimes, int refreshLimit) {
        RoleMission roleMission = getRoleMission(rid);
        roleMission.getDropData().clear();
        List<ImmutableThing> result = new ArrayList<>();
        for (int i = 1; i <= totalTimes; i++) {
            result.addAll(getRewardUnique(roleMission, missionId, onceDropTimes));
            if (i % refreshLimit == 0) {
                roleMission.getDropData().clear();
            }
        }
        List<ImmutableThing> rewardThings = ImmutableThingUtil.mergeThing(result);
        thingService.add(rid, rewardThings, GameEvent.GM);
    }

    /**
     * 掉落
     *
     * @param roleMission    关卡数据
     * @param rewardMissionId 掉落配置
     * @param dropTimes      掉落次数
     * @return
     */
    public List<ImmutableThing> getRewardUnique(RoleMission roleMission, int rewardMissionId, int dropTimes) {
        CChapterreward cChapterreward = chapterrewardSysCache.getOrThrow(rewardMissionId);
        int dropGroupId = cChapterreward.getDrop_group();

        List<CDropTrigger> dropGroup = dropTriggerSysCache.getDropGroup(dropGroupId);

        if (Objects.isNull(dropGroup)) {
            return Collections.emptyList();
        }
        Map<Integer, DropData> dropDataMap = roleMission.getDropData();

        List<ImmutableThing> resultList = new ArrayList<>();
        for (int i = 0; i < dropTimes; i++) {

            for (CDropTrigger dropTrigger : dropGroup) {
                DropData dropData = dropDataMap.computeIfAbsent(dropTrigger.getItem_group_type(), k -> new DropData());
                // 判断是否达到掉落上限
                if (dropData.getNum() >= dropTrigger.getDrop_item_max()) {
                    continue;
                }
                // 达到最大必出次数，或者随机到了，这里需要 -1 才能到达次数的时候触发
                if (dropData.getMissTimes() >= dropTrigger.getDrop_trigger_guarantee() - 1
                        || RandomUtil.lucky(GameConstant.MILLION, dropTrigger.getTrigger_chance())) {
                    ImmutableThing dropThing = dropGroupSysCache.getDropThing(dropTrigger.getDrop_trigger_id());
                    dropData.setNum(dropData.getNum() + dropThing.getItem_num());
                    dropData.setMissTimes(0);

                    resultList.add(dropThing);
                } else {
                    dropData.setMissTimes(dropData.getMissTimes() + 1);
                }
            }
        }
        return ImmutableThingUtil.mergeThing(resultList);
    }

    /**
     * 纯随机掉落
     *
     * @param roleMission    关卡数据
     * @param rewardMissionId 掉落配置
     * @param dropTimes      掉落次数
     * @return
     */
    public List<ImmutableThing> getRandomReward(RoleMission roleMission, int rewardMissionId, int dropTimes) {
        CChapterreward cChapterreward = chapterrewardSysCache.getOrThrow(rewardMissionId);
        int dropGroupId = cChapterreward.getDrop_group();

        List<CDropTrigger> dropGroup = dropTriggerSysCache.getDropGroup(dropGroupId);

        if (Objects.isNull(dropGroup)) {
            return Collections.emptyList();
        }

        List<ImmutableThing> resultList = new ArrayList<>();
        for (int i = 0; i < dropTimes; i++) {

            for (CDropTrigger dropTrigger : dropGroup) {
                // 达到最大必出次数，或者随机到了，这里需要 -1 才能到达次数的时候触发
                if (RandomUtil.lucky(GameConstant.MILLION, dropTrigger.getTrigger_chance())) {
                    ImmutableThing dropThing = dropGroupSysCache.getDropThing(dropTrigger.getDrop_trigger_id());

                    resultList.add(dropThing);
                }
            }
        }
        return ImmutableThingUtil.mergeThing(resultList);
    }

    /**
     * 发送挂机时长
     *
     * @param rid
     */
    public void sendIdleList(long rid) {
        Role role = roleService.getOrThrow(rid);
        BattleGMsg.GResChapterItemList.Builder builder = BattleGMsg.GResChapterItemList.newBuilder();
        RoleMission roleMission = this.getRoleMission(role.getId());
        builder.setRewardTime(roleMission.getStartTime());
        builder.setMaxRewardTime(roleVipService.getIdleMaxTime(rid));
        contextManager.write(rid, CmdCode._3004, builder.build());
    }

    public List<ImmutableThing> dropReward(RoleMission roleMission, int rewardMissionId, int idleTime) {
        List<ImmutableThing> rewardList = new ArrayList<>();
        while (idleTime + roleMission.getDropRewardTime() >= IdleConst.DROPS_MAX_RESET_TIME) {
            int curtDropTime = IdleConst.DROPS_MAX_RESET_TIME - roleMission.getDropRewardTime();
            int curtDropNum = (int) Math.round(curtDropTime * 1.0 / IdleConst.DROP_FREQUENCY);
            // 挂机道具收益
            if (curtDropNum > 0)
                rewardList.addAll(getRewardUnique(roleMission, rewardMissionId, curtDropNum));
            roleMission.setDropRewardTime(0);
            roleMission.getDropData().clear();
            idleTime -= curtDropTime;
        }
        if (idleTime > 0) {
            int nextDropNum = (int) Math.round(idleTime * 1.0 / IdleConst.DROP_FREQUENCY);
            // 挂机道具收益
            if (nextDropNum > 0)
                rewardList.addAll(getRewardUnique(roleMission, rewardMissionId, nextDropNum));
        }
        roleMission.setDropRewardTime(roleMission.getDropRewardTime() + idleTime);
        updateRoleMission(roleMission);
        return rewardList;
    }

    /**
     * 挂机奖励
     *
     * @param rid
     * @param idleTime
     * @return
     */
    public List<ImmutableThing> idleBattleReward(long rid, int idleTime) {

        Role role = roleService.getOrThrow(rid);
        RoleMission roleMission = getRoleMission(role.getId());

        // 资源奖励
        int dropNumber = idleTime / IdleConst.DROP_FREQUENCY;
        // 基础收益和在线挂机奖励一样，修改时需要同步修改
        // 已通关的最大关卡
        int max_mission = roleMission.getChapterId();
        CChapterreward cChapterreward = chapterrewardSysCache.getOrThrow(max_mission == 0 ? 1 : max_mission);
        // 基础收益
        List<ImmutableThing> baseReward = ImmutableThingUtil.multiplyThing(cChapterreward.getReward_base(), dropNumber);
        // 挂机道具收益
        int rewardMissionId = 1;
        if (roleMission.getChapterId() > rewardMissionId) {
            rewardMissionId = roleMission.getChapterId();
        }

        List<ImmutableThing> promotion016DragonDrops = promotion016DragonInfoService.randomQuickDrops(role.getId(), idleTime);
        List<ImmutableThing> promotion034Drops = promotion034ZhuShenService.randomQuickDrops(role.getId(), idleTime);
        List<ImmutableThing> promotion044Drops = promotion044FiresShopService.randomQuickDrops(role.getId(), idleTime);

        //添加资源
        List<ImmutableThing> rewardList = new ArrayList<>();
        rewardList.addAll(baseReward); // 基础
        rewardList.addAll(dropReward(roleMission, rewardMissionId, idleTime));// 道具收益
        rewardList.addAll(promotion016DragonDrops);// 活动获得
        rewardList.addAll(promotion034Drops);
        rewardList.addAll(promotion044Drops);

        //神职特权收益加成
        List<ImmutableThing> addReward = clergyService.clergyEarnings(role, ClergyPrivilegeType.IDLE_AWARD, rewardList);

        //基础资源掉落
        Map<Integer, ImmutableThing> baseRewardMap = ListMapUtil.listToMap(baseReward, ImmutableThing::getItem_type);
        //VIP挂机加成(只对基础资源加成)
        if (role.getGoddessVip() > 0) {
            CGoddessVip cGoddessVip = goddessVipSysCache.getOrThrow(role.getGoddessVip());
            ThingService.addBonus(rewardList, baseRewardMap, cGoddessVip.getHangBonusList());
        }

        //世界等级增益
        if (role.getLevel() >= IdleConst.WORLD_GAIN_LEVEL && worldLevelService.getWorldLevel() - role.getLevel() > 0) {
            List<ThingBonus> worldLevelExpBonus = worldLevelGainExpSysCache.getWorldLevelGain(worldLevelService.getWorldLevel() - role.getLevel());
            ThingService.addBonus(rewardList, baseRewardMap, worldLevelExpBonus, PrivilegeEffectType.IDLE_ROLE_EXP);
        }

        //特权礼包挂机资源加成
        //角色经验特权加成
        List<ThingBonus> roleExpBonus = promotion010PrivilegeGiftService.getPrivilegeBonus(role.getId(), PrivilegeEffectType.IDLE_ROLE_EXP);
        ThingService.addBonus(rewardList, baseRewardMap, roleExpBonus, PrivilegeEffectType.IDLE_ROLE_EXP);
        //金币特权加成
        List<ThingBonus> goldBonus = promotion010PrivilegeGiftService.getPrivilegeBonus(role.getId(), PrivilegeEffectType.IDLE_GOLD);
        ThingService.addBonus(rewardList, baseRewardMap, goldBonus, PrivilegeEffectType.IDLE_GOLD);
        //英雄经验特权加成
        List<ThingBonus> heroExpBonus = promotion010PrivilegeGiftService.getPrivilegeBonus(role.getId(), PrivilegeEffectType.IDLE_HERO_EXP);
        ThingService.addBonus(rewardList, baseRewardMap, heroExpBonus, PrivilegeEffectType.IDLE_HERO_EXP);

        rewardList.addAll(addReward);
        //特殊奖励
        return ImmutableThingUtil.mergeThing(rewardList);
    }
}
