package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.service;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.ItemSysCache;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeAdventureSysCache;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeBoxSysCache;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeFleetDurabilitySysCache;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeFleetSkillSysCache;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeFleetSysCache;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeProductSysCache;
import com.ayjs.mxzg.config.excel.constant.SpaceTimeAdventureConst;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.excel.entity.CItem;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeAdventure;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeBox;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeEventShow;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeFleet;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeFleetDurability;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeFleetSkill;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeProduct;
import com.ayjs.mxzg.config.struct.FleetSailingStruct;
import com.ayjs.mxzg.config.struct.FleetUnlockStruct;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.backpack.service.processor.ThingType;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.constant.FleetBuffEnum;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.constant.FleetEventType;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.constant.FleetSkillEnum;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.dao.SpaceTimeInfoDao;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.domain.SpaceTimeInfo;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.event.SailingEndEvent;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.event.SailingProgressEvent;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.executor.FleetEventHolder;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.struct.FleetBoxInfo;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.SpaceTimeAdventureGMsg;
import com.ayjs.mxzg.template.constant.GameConstant;
import com.fasterxml.jackson.databind.node.IntNode;
import org.checkerframework.checker.units.qual.A;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @author hyx
 */
@Service
public class SpaceTimeInfoService implements IRechargeBuyingService {

    @Autowired
    private SpaceTimeInfoDao spaceTimeInfoDao;
    @Autowired
    private SpaceTimeFleetSysCache spaceTimeFleetSysCache;
    @Autowired
    private SpaceTimeFleetSkillSysCache spaceTimeFleetSkillSysCache;
    @Autowired
    private SpaceTimeAdventureSysCache spaceTimeAdventureSysCache;
    @Autowired
    private SpaceTimeBoxSysCache spaceTimeBoxSysCache;
    @Autowired
    private SpaceTimeFleetDurabilitySysCache spaceTimeFleetDurabilitySysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private FleetEventHolder fleetEventHolder;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private ItemSysCache itemSysCache;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private SpaceTimeProductSysCache spaceTimeProductSysCache;
    @Autowired
    private ContextManager contextManager;

    /**
     * 执行事件
     *
     * @param fleetEventType
     * @param spaceTimeInfo
     * @param condition
     */
    public void executor(FleetEventType fleetEventType, SpaceTimeInfo spaceTimeInfo, int condition) {
        fleetEventHolder.eventExecutor(fleetEventType, spaceTimeInfo, condition);
    }

    public SpaceTimeInfo getInfo(long rid) {
        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoDao.get(rid);
        if (spaceTimeInfo == null) {
            spaceTimeInfo = new SpaceTimeInfo();
            spaceTimeInfo.setRid(rid);
            spaceTimeInfo.setFleetLevel(1);
            CSpaceTimeFleet cSpaceTimeFleet = spaceTimeFleetSysCache.getOrThrow(spaceTimeInfo.getFleetLevel());
            spaceTimeInfo.setEnergy(cSpaceTimeFleet.getEnergy());
            spaceTimeInfo.setDurability(cSpaceTimeFleet.getDurability());
            for (FleetSkillEnum fleetSkillEnum : FleetSkillEnum.values()) {
                spaceTimeInfo.getSkillMap().put(fleetSkillEnum.getType(), 1);
            }
            spaceTimeInfoDao.add(spaceTimeInfo);
        }
        //恢复体力
        this.regainEnergy(spaceTimeInfo);
        //关闭商店
        if (spaceTimeInfo.getShopEndTime() > 0 && spaceTimeInfo.getShopEndTime() < DateTimeUtil.currentSecond()) {
            spaceTimeInfo.setShopEndTime(0);
            spaceTimeInfo.getShopItems().clear();
            this.update(spaceTimeInfo);
        }

        return spaceTimeInfo;
    }

    /**
     * 恢复体力
     *
     * @param spaceTimeInfo
     */
    private void regainEnergy(SpaceTimeInfo spaceTimeInfo) {
        CSpaceTimeFleet cSpaceTimeFleet = spaceTimeFleetSysCache.getOrThrow(spaceTimeInfo.getFleetLevel());
        if (spaceTimeInfo.getEnergy() < cSpaceTimeFleet.getEnergy()) {
            int energy = (DateTimeUtil.currentSecond() - spaceTimeInfo.getEnergyTime()) / cSpaceTimeFleet.getEnergy_regain_time();
            if (energy > 0) {
                spaceTimeInfo.setEnergy(Math.min(energy + spaceTimeInfo.getEnergy(), cSpaceTimeFleet.getEnergy()));
                spaceTimeInfo.setEnergyTime(spaceTimeInfo.getEnergy() == cSpaceTimeFleet.getEnergy() ?
                        0 : spaceTimeInfo.getEnergyTime() + energy * cSpaceTimeFleet.getEnergy_regain_time());
                this.update(spaceTimeInfo);
            }
        }
    }

    /**
     * 添加临时背包
     *
     * @param spaceTimeInfo
     * @param rewardList
     * @return
     */
    public List<ObjectGMsg.PSBackpackData> addItem(SpaceTimeInfo spaceTimeInfo, List<ImmutableThing> rewardList, GameEvent gameEvent) {
        List<ObjectGMsg.PSBackpackData> builderList = new ArrayList<>();
        for (ImmutableThing immutableThing : rewardList) {

            ObjectGMsg.PSBackpackData.Builder builder = ObjectGMsg.PSBackpackData.newBuilder();
            builder.setNum(immutableThing.getItem_num());
            builder.setType(immutableThing.getItem_type());

            CItem cItem = itemSysCache.getOrThrow(immutableThing.getItem_type());
            if (cItem.getType() == ThingType.FLEET_BOX.getType()) {

                CSpaceTimeBox cSpaceTimeBox = DropUtil.randomDrop(spaceTimeBoxSysCache.getMap(immutableThing.getItem_type()));
                this.addFleetBox(spaceTimeInfo.getRid(), cSpaceTimeBox.getIdx());

                builder.setId(cSpaceTimeBox.getIdx());
            } else {
                spaceTimeInfo.getCargoHoldItem().add(immutableThing);
                List<ImmutableThing> list = ImmutableThingUtil.mergeThing(spaceTimeInfo.getCargoHoldItem());
                spaceTimeInfo.getCargoHoldItem().clear();
                spaceTimeInfo.getCargoHoldItem().addAll(list);
                this.update(spaceTimeInfo);
            }

            builderList.add(builder.build());
        }
        return builderList;
    }

    /**
     * 航行结算
     *
     * @param spaceTimeInfo
     */
    public List<ImmutableThing> settlement(SpaceTimeInfo spaceTimeInfo) {
        List<ImmutableThing> rewardList = new ArrayList<>();
        //固定道具
        CSpaceTimeAdventure cSpaceTimeAdventure = spaceTimeAdventureSysCache.getOrThrow(spaceTimeInfo.getRouteId());
        rewardList.addAll(cSpaceTimeAdventure.getFix_reward());
        //材料
        //增减益BUFF
        CSpaceTimeFleetSkill cSpaceTimeFleetSkill = spaceTimeFleetSkillSysCache.getSkill(FleetSkillEnum.CHUAN_CANG.getType(),
                spaceTimeInfo.getSkillMap().get(FleetSkillEnum.CHUAN_CANG.getType()));
        CSpaceTimeFleetDurability cSpaceTimeFleetDurability = spaceTimeFleetDurabilitySysCache.getConfig(spaceTimeInfo.getDurability());

        float multiply = (float) (GameConstant.WAN + cSpaceTimeFleetSkill.getFleet_item() - cSpaceTimeFleetDurability.getDecrease_item()) / (float) GameConstant.WAN;
        rewardList.addAll(ImmutableThingUtil.multiplyThing(spaceTimeInfo.getCargoHoldItem(), multiply));
        //物资
        for (FleetBoxInfo fleetBoxInfo : spaceTimeInfo.getCargoHoldBox()) {
            CSpaceTimeBox cSpaceTimeBox = spaceTimeBoxSysCache.getOrThrow(fleetBoxInfo.getBoxId());
            rewardList.addAll(cSpaceTimeBox.getReward());
        }
        rewardList = ImmutableThingUtil.mergeThing(rewardList);
        //添加道具
        thingService.add(spaceTimeInfo.getRid(), rewardList, GameEvent.SPACE_TIME_SAILING_END, NoticeType.SLIENT);

        return rewardList;
    }

    /**
     * 重置航队数据
     *
     * @param spaceTimeInfo
     */
    public void cleanSailingData(SpaceTimeInfo spaceTimeInfo) {
        //清除船舱
        spaceTimeInfo.getCargoHoldBox().clear();
        spaceTimeInfo.getCargoHoldItem().clear();
        spaceTimeInfo.setRouteId(0);
        spaceTimeInfo.setStartTime(0);
        spaceTimeInfo.setRemakeTime(0);
        spaceTimeInfo.setSpeedBuff(0);
        spaceTimeInfo.setNotProgress(0);
        spaceTimeInfo.getEventIds().clear();
        //关闭商店
        spaceTimeInfo.setShopEndTime(0);
        spaceTimeInfo.getShopItems().clear();
        //恢复体力
        CSpaceTimeFleet cSpaceTimeFleet = spaceTimeFleetSysCache.getOrThrow(spaceTimeInfo.getFleetLevel());
        spaceTimeInfo.setEnergy(cSpaceTimeFleet.getEnergy());
        //恢复耐久度
        CSpaceTimeFleetSkill cSpaceTimeFleetSkill = spaceTimeFleetSkillSysCache.getSkill(FleetSkillEnum.JIAN_DUI_ZHUANG_JIA.getType()
                , spaceTimeInfo.getSkillMap().getOrDefault(FleetSkillEnum.JIAN_DUI_ZHUANG_JIA.getType(), 1));
        spaceTimeInfo.setDurability(cSpaceTimeFleetSkill.getFleet_endurance());
        //航线礼包
        spaceTimeInfo.setProductEndTime(0);
        spaceTimeInfo.setProductIdx(0);
        spaceTimeInfo.setProductBuy(0);

        //清除布阵数据
        this.cleanHeroLineup(spaceTimeInfo.getRid());

        this.update(spaceTimeInfo);
    }

    private void cleanHeroLineup(long rid) {
        HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(rid, LineUpType.SPACE_TIME_WEAPON);
        heroLineUp.getFormationMap().clear();
        heroLineUpService.updateHeroLineUp(heroLineUp);
        heroLineUp = heroLineUpService.getLineUpByType(rid, LineUpType.SPACE_TIME_IMPETUS);
        heroLineUp.getFormationMap().clear();
        heroLineUpService.updateHeroLineUp(heroLineUp);
    }

    /**
     * 增加舰队经验值
     *
     * @param rid
     * @param addExp
     */
    public void addExp(long rid, long addExp) {
        SpaceTimeInfo spaceTimeInfo = this.getInfo(rid);
        CSpaceTimeFleet cSpaceTimeFleet = spaceTimeFleetSysCache.getOrThrow(spaceTimeInfo.getFleetLevel());
        if (spaceTimeInfo.getFleetLevel() >= spaceTimeFleetSysCache.getMaxLevel()) {
            spaceTimeInfo.setFleetExp(Math.min(spaceTimeInfo.getFleetExp() + addExp, cSpaceTimeFleet.getNeed_exp()));
        } else {
            spaceTimeInfo.setFleetExp(spaceTimeInfo.getFleetExp() + addExp);
            while (spaceTimeInfo.getFleetExp() >= cSpaceTimeFleet.getNeed_exp()) {
                spaceTimeInfo.setFleetExp(spaceTimeInfo.getFleetExp() - cSpaceTimeFleet.getNeed_exp());
                spaceTimeInfo.setFleetLevel(spaceTimeInfo.getFleetLevel() + 1);
                spaceTimeInfo.setSkillNum(spaceTimeInfo.getSkillNum() + 1);
                if (spaceTimeInfo.getFleetLevel() >= spaceTimeFleetSysCache.getMaxLevel()) {
                    spaceTimeInfo.setFleetExp(Math.min(spaceTimeInfo.getFleetExp(), cSpaceTimeFleet.getNeed_exp()));
                    break;
                }
                cSpaceTimeFleet = spaceTimeFleetSysCache.getOrThrow(spaceTimeInfo.getFleetLevel());
            }
        }
        this.update(spaceTimeInfo);
    }

    /**
     * 船舱增加宝箱
     *
     * @param rid
     * @param boxId
     */
    public void addFleetBox(long rid, int boxId) {
        SpaceTimeInfo spaceTimeInfo = this.getInfo(rid);
        spaceTimeInfo.getCargoHoldBox().add(FleetBoxInfo.of(boxId, DateTimeUtil.currentSecond()));
        this.update(spaceTimeInfo);
    }

    public void update(SpaceTimeInfo spaceTimeInfo) {
        spaceTimeInfoDao.update(spaceTimeInfo);
    }

    /**
     * 当前航行里程
     *
     * @param spaceTimeInfo
     * @return
     */
    public long getSailingProgress(SpaceTimeInfo spaceTimeInfo) {
        long totalProgress = 0;
        if (spaceTimeInfo.getRouteId() > 0) {
            totalProgress = spaceTimeInfo.getNotProgress() + (DateTimeUtil.currentSecond() - spaceTimeInfo.getRemakeTime()) * this.getSailingSpeed(spaceTimeInfo);
            CSpaceTimeAdventure cSpaceTimeAdventure = spaceTimeAdventureSysCache.getOrThrow(spaceTimeInfo.getRouteId());
            totalProgress = Math.min(cSpaceTimeAdventure.getTotalProgress(), totalProgress);
        }
        return totalProgress;
    }

    /**
     * 当前航行速度
     *
     * @param spaceTimeInfo
     * @return
     */
    private int getSailingSpeed(SpaceTimeInfo spaceTimeInfo) {
        //基础速度
        CSpaceTimeFleet cSpaceTimeFleet = spaceTimeFleetSysCache.getOrThrow(spaceTimeInfo.getFleetLevel());
        //科技速度加成
        CSpaceTimeFleetSkill cSpaceTimeFleetSkill = spaceTimeFleetSkillSysCache.getSkill(FleetSkillEnum.DONG_LI_LU.getType(),
                spaceTimeInfo.getSkillMap().get(FleetSkillEnum.DONG_LI_LU.getType()));
        //耐久度减益
        CSpaceTimeFleetDurability cSpaceTimeFleetDurability = spaceTimeFleetDurabilitySysCache.getConfig(spaceTimeInfo.getDurability());
        //最终速度
        int speed = cSpaceTimeFleet.getSpeed() + cSpaceTimeFleet.getSpeed() * cSpaceTimeFleetSkill.getFleet_speed_add() / GameConstant.WAN
                - cSpaceTimeFleet.getSpeed() * cSpaceTimeFleetDurability.getDecrease_speed() / GameConstant.WAN + spaceTimeInfo.getSpeedBuff();
        return speed;
    }

    /**
     * 航行结束时间
     *
     * @param spaceTimeInfo
     * @return
     */
    public int getSailingEndTime(SpaceTimeInfo spaceTimeInfo) {
        int entTime = 0;
        if (spaceTimeInfo.getRouteId() > 0) {
            CSpaceTimeAdventure cSpaceTimeAdventure = spaceTimeAdventureSysCache.getOrThrow(spaceTimeInfo.getRouteId());
            long progress = cSpaceTimeAdventure.getTotalProgress() - spaceTimeInfo.getNotProgress();
            entTime = (int) (progress / this.getSailingSpeed(spaceTimeInfo)) + spaceTimeInfo.getRemakeTime();
        }
        return entTime;
    }

    /**
     * 增加航行速度
     *
     * @param spaceTimeInfo
     * @param addSpeed(万分比)
     * @return
     */
    private void addFleetSpeed(SpaceTimeInfo spaceTimeInfo, int addSpeed) {
        this.changeSpeed(spaceTimeInfo, addSpeed);
    }

    /**
     * 减少航行速度
     *
     * @param spaceTimeInfo
     * @param costSpeed
     */
    private void costFleetSpeed(SpaceTimeInfo spaceTimeInfo, int costSpeed) {
        this.changeSpeed(spaceTimeInfo, -costSpeed);
    }

    /**
     * 改变航行速度
     *
     * @param spaceTimeInfo
     * @param changeSpeed
     */
    private void changeSpeed(SpaceTimeInfo spaceTimeInfo, int changeSpeed) {
        //以当前速度航行里程
        int addProgress = this.getSailingSpeed(spaceTimeInfo) * (DateTimeUtil.currentSecond() - spaceTimeInfo.getRemakeTime());
        //更新舰队航行状态
        CSpaceTimeFleet cSpaceTimeFleet = spaceTimeFleetSysCache.getOrThrow(spaceTimeInfo.getFleetLevel());
        spaceTimeInfo.setSpeedBuff(spaceTimeInfo.getSpeedBuff() + cSpaceTimeFleet.getSpeed() * changeSpeed / GameConstant.WAN);
        spaceTimeInfo.setNotProgress(spaceTimeInfo.getNotProgress() + addProgress);
        spaceTimeInfo.setRemakeTime(DateTimeUtil.currentSecond());
        this.update(spaceTimeInfo);
    }

    /**
     * 增加耐久度
     *
     * @param spaceTimeInfo
     * @param addDurability
     */
    public void addDurability(SpaceTimeInfo spaceTimeInfo, int addDurability) {
        //先计算以当前速度航行的里程
        this.changeSpeed(spaceTimeInfo, 0);

        CSpaceTimeFleetSkill cSpaceTimeFleetSkill = spaceTimeFleetSkillSysCache.getSkill(FleetSkillEnum.JIAN_DUI_ZHUANG_JIA.getType()
                , spaceTimeInfo.getSkillMap().getOrDefault(FleetSkillEnum.JIAN_DUI_ZHUANG_JIA.getType(), 1));
        spaceTimeInfo.setDurability(Math.min(spaceTimeInfo.getDurability() + addDurability, cSpaceTimeFleetSkill.getFleet_endurance()));
        this.update(spaceTimeInfo);
    }

    /**
     * 减少耐久度
     *
     * @param spaceTimeInfo
     * @param costDurability
     */
    private void costDurability(SpaceTimeInfo spaceTimeInfo, int costDurability) {
        //先计算以当前速度航行的里程
        this.changeSpeed(spaceTimeInfo, 0);

        spaceTimeInfo.setDurability(Math.max(spaceTimeInfo.getDurability() - costDurability, 0));
        this.update(spaceTimeInfo);
    }

    /**
     * 增加里程
     *
     * @param spaceTimeInfo
     * @param progress
     */
    public void addProgress(SpaceTimeInfo spaceTimeInfo, int progress) {
        spaceTimeInfo.setNotProgress(spaceTimeInfo.getNotProgress() + progress);
        this.update(spaceTimeInfo);
    }

    /**
     * 添加增益BUFF
     *
     * @param spaceTimeInfo
     * @param buff
     */
    public List<SpaceTimeAdventureGMsg.PSFleetBuff> addBuff(SpaceTimeInfo spaceTimeInfo, List<FleetSailingStruct> buff) {
        List<SpaceTimeAdventureGMsg.PSFleetBuff> builders = new ArrayList<>();

        for (FleetSailingStruct fleetSailingStruct : buff) {
            if (fleetSailingStruct.getType() == FleetBuffEnum.JIAN_DUI_SU_DU.getType()) {
                //速度
                this.addFleetSpeed(spaceTimeInfo, fleetSailingStruct.getEffect());
            } else if (fleetSailingStruct.getType() == FleetBuffEnum.JIAN_DUI_NAI_JIU.getType()) {
                //耐久
                this.addDurability(spaceTimeInfo, fleetSailingStruct.getEffect());
            } else if (fleetSailingStruct.getType() == FleetBuffEnum.JIAN_DUI_JIN_DU.getType()) {
                //里程
                this.addProgress(spaceTimeInfo, fleetSailingStruct.getEffect() * SpaceTimeAdventureConst.PROGRESS_TIMES);
            }

            builders.add(this.builderFleetBuff(fleetSailingStruct.getType(), fleetSailingStruct.getEffect()));
        }
        eventBus.post(SailingProgressEvent.of(spaceTimeInfo.getRid()));

        return builders;
    }

    /**
     * 添加减益BUFF
     *
     * @param spaceTimeInfo
     * @param debuff
     */
    public List<SpaceTimeAdventureGMsg.PSFleetBuff> addDebuff(SpaceTimeInfo spaceTimeInfo, List<FleetSailingStruct> debuff) {
        List<SpaceTimeAdventureGMsg.PSFleetBuff> builders = new ArrayList<>();

        for (FleetSailingStruct fleetSailingStruct : debuff) {
            if (fleetSailingStruct.getType() == FleetBuffEnum.JIAN_DUI_SU_DU.getType()) {
                //速度
                this.costFleetSpeed(spaceTimeInfo, fleetSailingStruct.getEffect());
            } else if (fleetSailingStruct.getType() == FleetBuffEnum.JIAN_DUI_NAI_JIU.getType()) {
                //耐久
                this.costDurability(spaceTimeInfo, fleetSailingStruct.getEffect());
            } else if (fleetSailingStruct.getType() == FleetBuffEnum.JIAN_DUI_JIN_DU.getType()) {
                //里程
            }
            builders.add(this.builderFleetBuff(fleetSailingStruct.getType(), -fleetSailingStruct.getEffect()));
        }
        eventBus.post(SailingProgressEvent.of(spaceTimeInfo.getRid()));

        return builders;
    }


    public boolean containsRoute(SpaceTimeInfo spaceTimeInfo, CSpaceTimeEventShow cSpaceTimeEventShow) {
        List<Integer> routes = cSpaceTimeEventShow.getRoute().stream().map(FleetUnlockStruct::getUnlock_route).collect(Collectors.toList());
        for (int route : routes) {
            if (!spaceTimeInfo.getUnlockRoutes().contains(route)) {
                return true;
            }
        }
        return false;
    }

    public SpaceTimeAdventureGMsg.PSFleetSkillData.Builder builderFleetSkill(int skillType, int skillLevel) {
        SpaceTimeAdventureGMsg.PSFleetSkillData.Builder data = SpaceTimeAdventureGMsg.PSFleetSkillData.newBuilder();
        data.setSkillType(skillType);
        data.setSkillLevel(skillLevel);
        return data;
    }

    public SpaceTimeAdventureGMsg.PSGoodsData.Builder builderGoodsData(int boxId, int time) {
        SpaceTimeAdventureGMsg.PSGoodsData.Builder data = SpaceTimeAdventureGMsg.PSGoodsData.newBuilder();
        data.setIdx(boxId);
        data.setTime(time);
        return data;
    }

    public SpaceTimeAdventureGMsg.PSFleetBuff builderFleetBuff(int buffId, int effect) {
        SpaceTimeAdventureGMsg.PSFleetBuff.Builder data = SpaceTimeAdventureGMsg.PSFleetBuff.newBuilder();
        data.setBuffId(buffId);
        data.setEffect(effect);
        return data.build();
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.SPACE_TIME_PRODUCT;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        SpaceTimeInfo spaceTimeInfo = this.getInfo(rid);
        if (spaceTimeInfo.getProductEndTime() < DateTimeUtil.currentSecond()) {
            return false;
        }
        int idx = spaceTimeInfo.getProductIdx();
        CSpaceTimeProduct cSpaceTimeProduct = spaceTimeProductSysCache.getOrThrow(idx);
        if (cSpaceTimeProduct.getProduct_id() != productId) {
            return false;
        }
        if (spaceTimeInfo.getProductBuy() >= cSpaceTimeProduct.getBuy_limit()) {
            return false;
        }
        return true;
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        SpaceTimeInfo spaceTimeInfo = this.getInfo(rid);

        spaceTimeInfo.setProductBuy(spaceTimeInfo.getProductBuy() + 1);
        this.update(spaceTimeInfo);

        CSpaceTimeProduct cSpaceTimeProduct = spaceTimeProductSysCache.getOrThrow(spaceTimeInfo.getProductIdx());
        thingService.add(rid, cSpaceTimeProduct.getReward(), GameEvent.SPACE_TIME_BUY_PRODUCT);

        SpaceTimeAdventureGMsg.GResFleetGiftBuy.Builder builder = SpaceTimeAdventureGMsg.GResFleetGiftBuy.newBuilder();
        builder.setProductEndTime(spaceTimeInfo.getProductEndTime());
        builder.setProductId(spaceTimeInfo.getProductIdx());
        builder.setProductBuy(spaceTimeInfo.getProductBuy());
        contextManager.write(rid, CmdCode._74149, builder.build());

    }
}
