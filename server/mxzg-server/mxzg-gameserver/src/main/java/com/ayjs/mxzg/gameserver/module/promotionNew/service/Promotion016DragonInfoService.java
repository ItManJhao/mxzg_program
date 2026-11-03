/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion016DragonMarkDropsSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.PromotionItemRetrieveSysCache;
import com.ayjs.mxzg.config.excel.constant.IdleConst;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion016DragonMarkDrops;
import com.ayjs.mxzg.config.excel.entity.promotion.IPromotionConfigDrops;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.module.backpack.domain.BackPack;
import com.ayjs.mxzg.gameserver.module.backpack.service.BackPackService;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion016DragonInfoDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.IPromotionDropsDomain;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion016DragonInfo;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleVipService;
import com.ayjs.mxzg.template.constant.GameConstant;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

/**
 * @author YY
 *
 */
@Service
public class Promotion016DragonInfoService extends BasePromotionService<Promotion016DragonInfo> {

    @Autowired
    private Promotion016DragonInfoDao promotion016DragonInfoDao;
    @Autowired
    private Promotion016DragonMarkDropsSysCache promotion016DragonMarkDropsSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private RoleVipService roleVipService;
    @Autowired
    private PromotionItemRetrieveSysCache promotionItemRetrieveSysCache;
    @Autowired
    private BackPackService backPackService;
    @Autowired
    private ThingService thingService;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.XIAN_SHI_DUI_HUAN;
    }

    @Override
    public IRepository<Promotion016DragonInfo> getRepository() {
        return promotion016DragonInfoDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion016DragonInfo promotion, PromotionControl control) {
        if (control.getStartTime() > promotion.getLastDropTime()) {
            promotion.setLastDropTime(control.getStartTime());
        }
        promotion.getDragonInfo().clear();
    }

    /**
     * 随机龙鳞印记掉落
     *
     * @param rid
     * @param hangTime 挂机时间
     */
    public List<ImmutableThing> randomIdleDrops(long rid, int hangTime) {
        if (!promotionControlService.canRecordPromotionData(rid, thisPromotionType())) {
            return Collections.emptyList();
        }
        Promotion016DragonInfo dragonInfo = getPromotionInfo(rid);
        CPromotion016DragonMarkDrops cDrop = promotion016DragonMarkDropsSysCache.getByTurns(dragonInfo.getTurns());

        List<ImmutableThing> rewardList = randomDrop(dragonInfo, cDrop, hangTime);
        if (!rewardList.isEmpty()) {
            updatePromotion(dragonInfo);
        }
        return rewardList;
    }

    @Override
    public void handleOnPromotionClear(PromotionControl control) {
        int itemType = promotionItemRetrieveSysCache.getOrThrow(control.getType()).getRetrieve_item();

        List<Promotion016DragonInfo> promotionList = getAllPromotionInfo();
        promotionList.stream().filter(promotion -> promotion.getTurnsTime() == control.getTurnsTime()).forEach(promotion -> {
            BackPack backPack = backPackService.getBackPack(promotion.getRid(), itemType);
            if (backPack != null && backPack.getNum() > 0) {
                ImmutableThing immutableThing = ImmutableThing.of(backPack.getItemId(), backPack.getNum());
                thingService.cost(promotion.getRid(), immutableThing, GameEvent.TRAFFIC_PERMIT_EXP);
            }
        });
    }

    /**
     * 挂机随机掉落
     * @param domain
     * @param dropsConfig
     * @param hangTime
     * @return
     */
    protected List<ImmutableThing> randomDrop(IPromotionDropsDomain domain, IPromotionConfigDrops dropsConfig,
                                              int hangTime) {
        if (dropsConfig == null) {
            return Collections.emptyList();
        }
        Role role = roleService.getOrThrow(domain.getRid());
        //挂机时间上限
        int maxHangTime = roleVipService.getIdleMaxTime(role.getId());
        int dropTime = TimeDateUtil.getCurrentTimeInt() - domain.getLastDropTime();
        boolean isMaxDropTime = false;
        if (dropTime > maxHangTime) {
            dropTime = maxHangTime;
            isMaxDropTime = true;
        }

        List<ImmutableThing> rewardList = dropsConfig.getReward();

        int dropCount = dropTime / dropsConfig.getGain_frequency();
        //掉落数量=稳定掉落数量+随机掉落数量
        int totalCount = dropCount;
        int randomCount = hangTime / IdleConst.DROP_FREQUENCY;
        totalCount += RandomUtil.randomUpperLimitMultiple(dropsConfig.getGain_chance(), GameConstant.MILLION, randomCount);
        if (totalCount > 0) {
            if (isMaxDropTime) {
                domain.setLastDropTime(TimeDateUtil.getCurrentTimeInt());
            } else {
                domain.setLastDropTime(domain.getLastDropTime() + dropsConfig.getGain_frequency() * dropCount);
            }
            rewardList = ImmutableThingUtil.multiplyThing(rewardList, totalCount);
            return rewardList;
        }
        return Collections.emptyList();
    }

    /**
     * 快速战斗时的龙纹印记掉落
     * @param rid
     * @param hangTime
     * @return
     */
    public List<ImmutableThing> randomQuickDrops(long rid, int hangTime) {
        if (!promotionControlService.canRecordPromotionData(rid, thisPromotionType())) {
            return Collections.emptyList();
        }
        Promotion016DragonInfo dragonInfo = getPromotionInfo(rid);
        CPromotion016DragonMarkDrops cDrop = promotion016DragonMarkDropsSysCache.getByTurns(dragonInfo.getTurns());
        return randomQuickDrop(dragonInfo, cDrop, hangTime);
    }

    /**
     * 快速战斗掉落
     * @param domain
     * @param dropsConfig
     * @param hangTime
     * @return
     */
    protected List<ImmutableThing> randomQuickDrop(IPromotionDropsDomain domain, IPromotionConfigDrops dropsConfig,
                                                   int hangTime) {
        if (dropsConfig == null) {
            return Collections.emptyList();
        }
        List<ImmutableThing> rewardList = dropsConfig.getReward();

        int dropCount = hangTime / dropsConfig.getGain_frequency();
        // 掉落数量=稳定掉落数量+随机掉落数量
        int randomCount = hangTime / IdleConst.DROP_FREQUENCY;
        int totalCount = dropCount
                + RandomUtil.randomUpperLimitMultiple(dropsConfig.getGain_chance(), GameConstant.MILLION, randomCount);
        if (totalCount > 0) {
            rewardList = ImmutableThingUtil.multiplyThing(rewardList, totalCount);
            return rewardList;
        }
        return Collections.emptyList();
    }

    @Override
    protected void onCreatingInfo(Promotion016DragonInfo promotion) {
        Role role = roleService.getOrThrow(promotion.getRid());
        promotion.setLastDropTime((int) (role.getCreateTime() / 1000));
    }
}
