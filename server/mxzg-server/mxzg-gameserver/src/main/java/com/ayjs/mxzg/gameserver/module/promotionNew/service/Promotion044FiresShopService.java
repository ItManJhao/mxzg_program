/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion044FiresShopDropsSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.PromotionItemRetrieveSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion044FiresShopDrops;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.backpack.domain.BackPack;
import com.ayjs.mxzg.gameserver.module.backpack.service.BackPackService;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion044FiresShopDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion044FiresShop;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion044FiresShopConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

/***
 * cwj
 */
@Service
public class Promotion044FiresShopService extends BasePromotionService<Promotion044FiresShop> {

    @Autowired
    private Promotion044FiresShopDao promotion044FiresShopDao;
    @Autowired
    private Promotion044FiresShopDropsSysCache promotion044FiresShopDropsSysCache;
    @Autowired
    private Promotion016DragonInfoService promotion016DragonInfoService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private PromotionItemRetrieveSysCache promotionItemRetrieveSysCache;
    @Autowired
    private BackPackService backPackService;
    @Autowired
    private ThingService thingService;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.QI_CAI_HUA_ZHANG;
    }

    @Override
    public IRepository<Promotion044FiresShop> getRepository() {
        return promotion044FiresShopDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion044FiresShop promotion, PromotionControl control) {
        if (control.getStartTime() > promotion.getLastDropTime()) {
            promotion.setLastDropTime(control.getStartTime());
        }
        promotion.getFiresShopInfo().clear();
    }

    public Promotion044FiresShopConfig getConfig(int idx) {
        return promotionControlService.getControl(thisPromotionType()).getConfig(idx, Promotion044FiresShopConfig.class);
    }

    @Override
    public void handleOnPromotionClear(PromotionControl control) {
        int itemType = promotionItemRetrieveSysCache.getOrThrow(control.getType()).getRetrieve_item();

        List<Promotion044FiresShop> promotionList = getAllPromotionInfo();
        promotionList.stream().filter(promotion -> promotion.getTurnsTime() == control.getTurnsTime()).forEach(promotion -> {
            BackPack backPack = backPackService.getBackPack(promotion.getRid(), itemType);
            if (backPack != null) {
                ImmutableThing immutableThing = ImmutableThing.of(backPack.getItemId(), backPack.getNum());
                thingService.cost(promotion.getRid(), immutableThing, GameEvent.TRAFFIC_PERMIT_EXP);
            }
        });
    }

    /**
     * 随机龙鳞印记掉落
     *
     * @param rid
     * @param hangTime 挂机时间
     */
    public List<ImmutableThing> randomIdleDrops(long rid, int hangTime) {
        if (!promotionControlService.isPromotionRecording(thisPromotionType())) {
            return Collections.emptyList();
        }
        Promotion044FiresShop promotionInfo = getPromotionInfo(rid);
        CPromotion044FiresShopDrops cDrop = promotion044FiresShopDropsSysCache.getAll().get(0);

        List<ImmutableThing> rewardList = promotion016DragonInfoService.randomDrop(promotionInfo, cDrop, hangTime);
        if (!rewardList.isEmpty()) {
            updatePromotion(promotionInfo);
        }
        return rewardList;
    }

    public List<ImmutableThing> randomQuickDrops(long rid, int hangTime) {
        if (!promotionControlService.isPromotionRecording(thisPromotionType())) {
            return Collections.emptyList();
        }
        Promotion044FiresShop promotionInfo = getPromotionInfo(rid);
        CPromotion044FiresShopDrops cDrop = promotion044FiresShopDropsSysCache.getAll().get(0);
        return promotion016DragonInfoService.randomQuickDrop(promotionInfo, cDrop, hangTime);
    }

    @Override
    protected void onCreatingInfo(Promotion044FiresShop promotion) {
        Role role = roleService.getOrThrow(promotion.getRid());
        promotion.setLastDropTime((int) (role.getCreateTime() / 1000));
    }
}
