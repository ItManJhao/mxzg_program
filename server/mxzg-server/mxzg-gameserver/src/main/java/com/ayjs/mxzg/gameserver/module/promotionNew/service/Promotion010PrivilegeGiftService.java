package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion010PrivilegeGiftSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion010PrivilegeGift;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ThingBonus;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PrivilegeEffectType;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PrivilegeType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.PrivilegeGiftDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PrivilegeGift;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.BuyPrivilegeEvent;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.Promotion010GMsg.GResPrivilegeGiftBuy;
import com.ayjs.mxzg.protocol.Promotion010GMsg.PSPrivilegeGift;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/15 21:01
 */
@Slf4j
@Service
public class Promotion010PrivilegeGiftService implements IRechargeBuyingService {

    @Autowired
    private PrivilegeGiftDao privilegeGiftDao;
    @Autowired
    private Promotion010PrivilegeGiftSysCache promotion010PrivilegeGiftSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private RoleService roleService;


    public List<PrivilegeGift> getPrivilegeGifts(long rid) {
        List<PrivilegeGift> list = privilegeGiftDao.list("rid", rid);
        int nowTime = TimeDateUtil.getCurrentTimeInt();
        for (PrivilegeGift gift : list) {
            if (gift.getEndTime() == 0) {
                continue;
            }
            if (gift.getActive() != 0 && nowTime >= gift.getEndTime()) {
                gift.setBuyCount(0);
                //使特权失效
                gift.setActive(0);
                privilegeGiftDao.update(gift);
            }
        }
        return list;
    }

    /**
     * 获取特权
     *
     * @param rid
     * @param type
     * @return
     */
    public PrivilegeGift getPrivilegeGift(long rid, PrivilegeType type) {
        List<PrivilegeGift> entities = getPrivilegeGifts(rid);
        for (PrivilegeGift gift : entities) {
            if (gift.getIdx() == type.getValue()) {
                return gift;
            }
        }
        return null;
    }

    /**
     * 获取特权加成系数，万分比
     *
     * @param rid
     * @param effectType
     * @return
     */
    public List<ThingBonus> getPrivilegeBonus(long rid, PrivilegeEffectType effectType) {
        List<PrivilegeGift> privilegeGiftList = getPrivilegeGifts(rid);

        if (CollectionUtil.isEmpty(privilegeGiftList)) {
            return Collections.emptyList();
        }
        List<ThingBonus> bonuses = new ArrayList<>();
        for (PrivilegeGift privilegeGift : privilegeGiftList) {

            if (privilegeGift.getEndTime() != 0 && TimeDateUtil.getCurrentTimeInt() > privilegeGift.getEndTime()) {
                continue;
            }
            CPromotion010PrivilegeGift cPrivilegeGift = promotion010PrivilegeGiftSysCache.getOrThrow(privilegeGift.getIdx());
            if (CollectionUtil.isEmpty(cPrivilegeGift.getBonus())) {
                continue;
            }
            for (ThingBonus bonus : cPrivilegeGift.getBonus()) {
                if (bonus.getEffect().equals(effectType.name())) {
                    bonuses.add(bonus);
                }
            }
        }

        return bonuses;
    }

    /**
     * 特权是否生效
     *
     * @param rid
     * @param type
     * @return
     */
    public boolean isPrivilegeActive(long rid, PrivilegeType type) {
        PrivilegeGift gift = getPrivilegeGift(rid, type);
        if (gift == null) {
            return false;
        }
        if (gift.getEndTime() == 0) {
            return true;
        }
        if (gift.getActive() == 1 && TimeDateUtil.getCurrentTimeInt() < gift.getEndTime()) {
            return true;
        }
        return false;
    }

    public void insert(PrivilegeGift privilegeGift) {
        privilegeGiftDao.add(privilegeGift);
    }

    public void update(PrivilegeGift privilegeGift) {
        privilegeGiftDao.update(privilegeGift);
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.PRIVILEGE_GIFT;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        CPromotion010PrivilegeGift cGift = promotion010PrivilegeGiftSysCache.getByProductId(productId);
        if (cGift == null) {
            return false;
        }
        if (cGift.getBuy_type() != 1) {
            return false;
        }
        Role role = roleService.getOrThrow(rid);
        if (role.getLevel() < cGift.getShow_level()) {
            return false;
        }

        PrivilegeGift gift = getPrivilegeGift(rid, PrivilegeType.valueOf(cGift.getIdx()));
        if (gift == null) {
            return true;
        }
        if (gift.getEndTime() == 0) {
            return false;
        }
        if (gift.getActive() == 1 && TimeDateUtil.getCurrentTimeInt() < gift.getEndTime()) {
            if (gift.getBuyCount() >= cGift.getLimit_num()) {
                return false;
            } else {
                return true;
            }
        }
        return true;
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        CPromotion010PrivilegeGift cGift = promotion010PrivilegeGiftSysCache.getByProductId(cBuyGem.getIdx());
        PrivilegeGift privilegeGift = addOrUpdatePrivilegeGift(rid, cGift);

        if (cGift.getIdx() != PrivilegeType.GOD_EQUIP.getValue()) {
            if (isGm) {
                thingService.add(rid, cGift.getItem(), GameEvent.GM_RECHARGE);
            } else {
                thingService.add(rid, cGift.getItem(), GameEvent.BUY_PRIVILEGE);
            }
        }

        GResPrivilegeGiftBuy.Builder builder = GResPrivilegeGiftBuy.newBuilder();
        builder.setData(serializePrivilegeGift(privilegeGift));
        contextManager.write(rid, CmdCode._20015, builder.build());
    }


    public PrivilegeGift addOrUpdatePrivilegeGift(long rid, CPromotion010PrivilegeGift cGift) {
        PrivilegeGift privilegeGift = getPrivilegeGift(rid, PrivilegeType.valueOf(cGift.getIdx()));
        if (privilegeGift == null) {
            privilegeGift = new PrivilegeGift();
            privilegeGift.setRid(rid);
            privilegeGift.setIdx(cGift.getIdx());
            insert(privilegeGift);
        }
        privilegeGift.setBuyCount(privilegeGift.getBuyCount() + 1);
        privilegeGift.setBuyTime(TimeDateUtil.getCurrentTimeInt());
        privilegeGift.setActive(1);
        if (cGift.getLimit_day() != 0) {
            if (cGift.getTime_mode() == 1) {
                privilegeGift.setEndTime(TimeDateUtil.getCurrentTimeInt() + cGift.getLimit_day() * TimeDateUtil.ONEDAYINT);
            } else {
                privilegeGift.setEndTime(TimeDateUtil.getTodayZeroTimeInt() + cGift.getLimit_day() * TimeDateUtil.ONEDAYINT);
            }
        }
        update(privilegeGift);
        eventBus.post(BuyPrivilegeEvent.of(rid, PrivilegeType.valueOf(cGift.getIdx())));
        return privilegeGift;
    }


    public PSPrivilegeGift serializePrivilegeGift(PrivilegeGift gift) {
        PSPrivilegeGift.Builder builder = PSPrivilegeGift.newBuilder();
        builder.setIdx(gift.getIdx());
        builder.setEndTime(gift.getEndTime());
        builder.setBuyCount(gift.getBuyCount());
        return builder.build();
    }
}
