package com.ayjs.mxzg.gameserver.module.crusadegroup.group.service;


import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.ItemSysCache;
import com.ayjs.mxzg.config.excel.cache.RewardGroupSysCache;
import com.ayjs.mxzg.config.excel.cache.crusadegroup.CrusadeGroupBuildSysCache;
import com.ayjs.mxzg.config.excel.cache.crusadegroup.CrusadeGroupMapSysCache;
import com.ayjs.mxzg.config.excel.constant.CrusadeGroupConst;
import com.ayjs.mxzg.config.excel.entity.CItem;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupBuild;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupMap;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.TerritoryType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.backpack.service.processor.ThingType;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.dao.RoleCrusadeGroupDao;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.CrusadeGroupHero;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.RoleCrusadeGroup;
import com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.event.ShenBinAddEvent;
import com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.event.ShenBinItemAddEvent;
import com.ayjs.mxzg.message.module.crusadegroup.group.dto.Territory;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class GroupService {

    @Autowired
    private RewardGroupSysCache rewardGroupSysCache;

    @Autowired
    private ItemSysCache itemSysCache;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private RoleCrusadeGroupDao roleCrusadeGroupDao;

    @Autowired
    private CrusadeGroupMapSysCache crusadeGroupMapSysCache;
    @Autowired
    private CrusadeGroupBuildSysCache crusadeGroupBuildSysCache;

    //获取讨伐团角色信息
    public RoleCrusadeGroup getRoleCrusadeGroup(long rid) {
        return roleCrusadeGroupDao.getOrCreate(rid);
    }

    //更新讨伐团玩家信息
    public void updateRoleCrusadeGroup(RoleCrusadeGroup roleCrusadeGroup) {
        roleCrusadeGroupDao.update(roleCrusadeGroup);
    }

    //判断玩家是否报名
    public boolean isRegistration(long rid) {
        RoleCrusadeGroup roleCrusadeGroup = getRoleCrusadeGroup(rid);
        return roleCrusadeGroup.isRegistration();
    }

    /**
     * 根据战报获取评价
     *
     * @param battleReport
     * @return
     */
    public List<Integer> buildEvaluationBy(BattleGMsg.BattleReport battleReport) {
        List<Integer> evaluationList = new ArrayList<>();
        int firstStar = battleReport.getWinId() == battleReport.getAttacker().getPlayerId() ? 1 : 0;
        evaluationList.add(firstStar);

        int secondStar = battleReport.getRoundsCount() <= CrusadeGroupConst.EVALUATION_SECOND_STAR_ROUND ? 1 : 0;
        evaluationList.add(secondStar);

        int thirdStar = battleReport.getLog().getAttackerLog().getHeroLogList().stream().noneMatch(hero -> hero.getHp() == 0) ? 1 : 0;
        evaluationList.add(thirdStar);
        return evaluationList;
    }

    /**
     * 根据评价的星级获取恢复的体力
     *
     * @param evaluationList
     * @return
     */
    public int getPhysicalRecoveryBy(List<Integer> evaluationList) {
        int starCount = (int) evaluationList.stream().filter(star -> star == 1).count();
        return CrusadeGroupConst.STAR_RECOVERY_PHYSICAL.getOrDefault(starCount, 0);
    }

    /**
     * 添加神兵精华
     *
     * @param rid
     * @param addNum
     * @return
     */
    public long addShenBinItem(long rid, long addNum) {
        if (addNum <= 0) {
            return -1;
        }
        RoleCrusadeGroup roleCrusadeGroup = getRoleCrusadeGroup(rid);
        long nowNum = roleCrusadeGroup.getForceNature();
        roleCrusadeGroup.setForceNature(nowNum + addNum);
        roleCrusadeGroup.updateForceNatureTotal(addNum);
        updateRoleCrusadeGroup(roleCrusadeGroup);
        eventBus.post(ShenBinItemAddEvent.of(rid, addNum, GameEvent.SHENBIN_ITEM_ADD));
        return addNum;
    }

    /**
     * 获取神兵精华数量
     *
     * @param rid
     * @return
     */
    public long getShenBinItemNum(long rid) {
        RoleCrusadeGroup roleCrusadeGroup = getRoleCrusadeGroup(rid);
        return roleCrusadeGroup.getForceNature();
    }

    /**
     * 神兵精华消费
     *
     * @param rid
     * @param needNum
     */
    public void shenBinItemCost(long rid, long needNum) {
        RoleCrusadeGroup roleCrusadeGroup = getRoleCrusadeGroup(rid);
        long num = roleCrusadeGroup.getForceNature();
        Asserts.isTrue(num > 0, ErrorCode.SHENBIN_NOT_ENOUGH.getValue(),
                () -> String.format("神兵精华不足，当前数量:%s,消费数量:%s"
                        , num, needNum));
        Asserts.isTrue(needNum > 0, ErrorCode.SHENBIN_NOT_ENOUGH.getValue(),
                () -> String.format("神兵精华不足，当前数量:%s,消费数量:%s"
                        , num, needNum));
        Asserts.isTrue(needNum <= num, ErrorCode.SHENBIN_NOT_ENOUGH.getValue(),
                () -> String.format("神兵精华不足，当前数量:%s,消费数量:%s"
                        , num, needNum));
        roleCrusadeGroup.setForceNature(num - needNum);
        updateRoleCrusadeGroup(roleCrusadeGroup);
    }

    /**
     * 增加神兵装备
     *
     * @param rid
     * @param itemMap
     * @return 返回当前成功添加神兵信息
     */
    public Map<Integer, Long> addShenBin(long rid, Map<Integer, Long> itemMap) {
        RoleCrusadeGroup roleCrusadeGroup = getRoleCrusadeGroup(rid);
        Map<Integer, Long> bagMap = roleCrusadeGroup.getShenBinMap();//当前背包神兵
        Map<Integer, Long> addMap = new HashMap<>();
        for (Map.Entry<Integer, Long> entry : itemMap.entrySet()) {
            int item_type = entry.getKey();
            long itemNum = entry.getValue();
            CItem cItem = itemSysCache.getById(item_type);
            if (cItem.getType() != ThingType.SHENBIN.getType()) {
                log.error("讨伐团-该道具不是神兵类型", item_type);
                continue;
            }
            long num = bagMap.getOrDefault(item_type, 0l);
            bagMap.put(item_type, num + itemNum);
            addMap.put(item_type, itemNum);
        }
        updateRoleCrusadeGroup(roleCrusadeGroup);
        eventBus.post(ShenBinAddEvent.of(rid, addMap));
        return addMap;
    }

    /**
     * 获取神兵数量
     *
     * @param rid
     * @param thingType
     * @return
     */
    public long getShenBinCount(long rid, int thingType) {
        RoleCrusadeGroup roleCrusadeGroup = getRoleCrusadeGroup(rid);
        //神兵
        return roleCrusadeGroup.getShenBinMap().getOrDefault(thingType, 0l);
    }

    /**
     * 神兵消费
     *
     * @param rid
     * @param itemMap
     */
    public void shenBinCost(long rid, Map<Integer, Long> itemMap) {
        //先检查是否足够
        prepareCost(rid, itemMap);
        RoleCrusadeGroup roleCrusadeGroup = getRoleCrusadeGroup(rid);
        Map<Integer, Long> bagMap = roleCrusadeGroup.getShenBinMap();
        Map<Integer, Long> currMap = new HashMap<>();
        for (Map.Entry<Integer, Long> entry : itemMap.entrySet()) {
            int item_type = entry.getKey();
            long itemNum = entry.getValue();
            long num = bagMap.getOrDefault(item_type, 0l);
            bagMap.put(item_type, num - itemNum);
            currMap.put(item_type, bagMap.get(item_type));
        }
        updateRoleCrusadeGroup(roleCrusadeGroup);
    }

    //检查装备是否足够
    private void prepareCost(long rid, Map<Integer, Long> itemMap) {
        RoleCrusadeGroup roleCrusadeGroup = getRoleCrusadeGroup(rid);
        Map<Integer, Long> bagMap = roleCrusadeGroup.getShenBinMap();
        for (Map.Entry<Integer, Long> entry : itemMap.entrySet()) {
            int item_type = entry.getKey();
            long itemNum = entry.getValue();
            long num = bagMap.getOrDefault(item_type, 0l);//拥有的数量
            Asserts.isTrue(num > 0, ErrorCode.SHENBIN_NOT_ENOUGH.getValue(),
                    () -> String.format("item_type:%s myNum <= 0 item_num:%s"
                            , item_type, itemNum));
            Asserts.isTrue(itemNum > 0, ErrorCode.SHENBIN_NOT_ENOUGH.getValue(),
                    () -> String.format("item_type:%s item_num <= 0 item_num:%s"
                            , item_type, itemNum));
            Asserts.isTrue(itemNum <= num, ErrorCode.SHENBIN_NOT_ENOUGH.getValue(),
                    () -> String.format("item_type:%s item_num > myNum item_num:%s"
                            , item_type, itemNum));
        }
    }

    /**
     * 刷新角色讨伐团的数据
     * @param roleCrusadeGroup
     */
    public void refreshProductivity(RoleCrusadeGroup roleCrusadeGroup){
        int totalProductivity = 0;
        for (Territory territory : roleCrusadeGroup.getTerritoryInfo().values()) {
            CCrusadeGroupMap map = crusadeGroupMapSysCache.getMap(territory.getId());
            CCrusadeGroupBuild build = crusadeGroupBuildSysCache.getBuild(map.getArea_level(), map.getBuilding_level(), map.getFight_type());
            double productivity = build.getCream_output();
            if(territory.isDevelopment()){
                productivity *= CrusadeGroupConst.PRODUCTION_INCREASE_RATIO;
            }
            totalProductivity += productivity;
        }
        roleCrusadeGroup.setProductivity(totalProductivity);
    }

    /**
     * 收取神兵精华
     * @param roleCrusadeGroup
     * @return
     */
    public int collectEssence(RoleCrusadeGroup roleCrusadeGroup){
        int totalEssence = 0;
        int now = LocalDateTimeUtil.toEpochSecond(LocalDateTime.now());
        for (Territory territory : roleCrusadeGroup.getTerritoryInfo().values()) {
            CCrusadeGroupMap map = crusadeGroupMapSysCache.getMap(territory.getId());
            CCrusadeGroupBuild build = crusadeGroupBuildSysCache.getBuild(map.getArea_level(), map.getBuilding_level(), map.getFight_type());
            double essence = build.getCream_output();
            if(territory.isDevelopment()){
                essence *= CrusadeGroupConst.PRODUCTION_INCREASE_RATIO;
            }
            int count = (now - territory.getEssenceSettlementTime()) / CrusadeGroupConst.ESSENCE_PRODUCTION_INTERVAL_S;

            if(count > 0){
                essence *= count;
                totalEssence += essence;
                territory.updateEssenceSettlementTime(count * CrusadeGroupConst.ESSENCE_PRODUCTION_INTERVAL_S);
            }
        }

        if(totalEssence > 0){
            roleCrusadeGroup.setLastSettlementTime(LocalDateTime.now());
        }

        return totalEssence;
    }

    /**
     * 收取神兵
     *
     * @param roleCrusadeGroup
     * @return
     */
    public Map<Integer, Long> collectShenBin(RoleCrusadeGroup roleCrusadeGroup){
        Map<Integer, Long> shenBinMap = new HashMap<>();
        int now = DateTimeUtil.currentSecond();
        for (Territory territory : roleCrusadeGroup.getTerritoryInfo().values()) {
            CCrusadeGroupMap map = crusadeGroupMapSysCache.getMap(territory.getId());
            CCrusadeGroupBuild build = crusadeGroupBuildSysCache.getBuild(map.getArea_level(), map.getBuilding_level(), map.getFight_type());
            if(build.getType() != TerritoryType.ORDINARY){
                continue;
            }
            int count = (now - territory.getShenbinSettlementTime()) / (build.getShenbing_cd() * 60);
            if(count > 0){
                List<ImmutableThing> allReward = new ArrayList<>();
                for(int i = 0; i < count; i++){
                    List<ImmutableThing> rewardList = rewardGroupSysCache.getRewardGroupThing(build.getShenbing_drop());
                    allReward.addAll(rewardList);
                }

                for (ImmutableThing thing : allReward) {
                    long num = shenBinMap.getOrDefault(thing.getThingId(), 0L);
                    shenBinMap.put(thing.getThingId(), num + thing.getItem_num());
                }

                territory.updateShenBinSettlementTime(count * build.getShenbing_cd() * 60);
            }
        }

        return shenBinMap;
    }

    /**
     * 恢复体力
     * @param roleCrusadeGroup
     */
    public void recoveryPhysical(RoleCrusadeGroup roleCrusadeGroup){
        int now = DateTimeUtil.currentSecond();
        int lastTime = LocalDateTimeUtil.toEpochSecond(roleCrusadeGroup.getRecoveryPhysicalTime());
        int interval = now - lastTime;
        int count = interval / CrusadeGroupConst.RECOVERY_PHYSICAL_INTERVAL_S;
        if(count == 0){
            return;
        }

        int physical = count * CrusadeGroupConst.RECOVERY_PHYSICAL;
        for (CrusadeGroupHero hero : roleCrusadeGroup.getHeroes().values()) {
            if(hero.notEmpty()){
                hero.recoveryPhysical(physical);
            }
        }

        roleCrusadeGroup.addRecoveryPhysicalTime(count * CrusadeGroupConst.RECOVERY_PHYSICAL_INTERVAL_S);
    }

}
