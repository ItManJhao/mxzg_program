package com.ayjs.mxzg.gameserver.module.limitBuy.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.BuyGemSysCache;
import com.ayjs.mxzg.config.excel.cache.OpenConditionSysCache;
import com.ayjs.mxzg.config.excel.cache.PromotionLimitedSetChapterSysCache;
import com.ayjs.mxzg.config.excel.cache.PromotionLimitedSetDaySysCache;
import com.ayjs.mxzg.config.excel.cache.PromotionLimitedSetLevelSysCache;
import com.ayjs.mxzg.config.excel.cache.PromotionLimitedSetSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.excel.entity.COpenCondition;
import com.ayjs.mxzg.config.excel.entity.CPromotionLimitedSet;
import com.ayjs.mxzg.config.excel.entity.CPromotionLimitedSetDay;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroGetEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroStarUpEvent;
import com.ayjs.mxzg.gameserver.module.limitBuy.dao.LimitProductionDao;
import com.ayjs.mxzg.gameserver.module.limitBuy.domain.LimitProduction;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.module.role.constant.EntryType;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.protocol.Task1GMsg;
import com.ayjs.mxzg.protocol.TaskObjGMsg;
import com.google.j2objc.annotations.AutoreleasePool;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2019/10/30
 **/
@Service
@Observer
public class LimitProductionService implements IRechargeBuyingService {
    @Autowired
    protected LimitProductionDao limitProductionDao;
    @Autowired
    protected BuyGemSysCache buyGemSysCache;
    @Autowired
    protected PromotionLimitedSetSysCache promotionLimitedSetSysCache;
    @Autowired
    protected ContextManager contextManager;
    @Autowired
    private ThingService thingService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private OpenConditionSysCache openConditionSysCache;
    @Autowired
    private PromotionLimitedSetDaySysCache promotionLimitedSetDaySysCache;
    @Autowired
    private ServerParamService serverParamService;

    /***
     * 获取所有限购商品
     * @param rid
     * @return
     */
    protected List<LimitProduction> getAll(long rid) {
        return limitProductionDao.list("rid", rid);
    }

    /***
     * 获取所有有效的物品限购商品
     * @param rid
     * @return
     */
    public List<LimitProduction> getAllAvail(long rid) {
        List<LimitProduction> list = getAll(rid);
        int now = DateTimeUtil.currentSecond();
        return list.stream().filter(entity -> entity.getExpireTime() > now).collect(Collectors.toList());
    }

    /***
     * 获取商品，包含过期的商品
     * @param rid
     * @param idx
     * @return
     */
    public LimitProduction get(long rid, int idx) {
        LimitProduction entity = getAll(rid).stream().filter(entityTemp -> entityTemp.getBuyGemIdx() == idx).findFirst().orElse(null);
        return entity;
    }

    public void sendData(long rid) {
        Task1GMsg.GResLimitGiftList.Builder builder = Task1GMsg.GResLimitGiftList.newBuilder();
        List<LimitProduction> list = getAllAvail(rid);
        list.forEach(limited -> {
            if (limited.getCount() > 0) {
                TaskObjGMsg.LimitGiftData.Builder limitGiftData = TaskObjGMsg.LimitGiftData.newBuilder();
                limitGiftData.setIdx(limited.getBuyGemIdx());
                limitGiftData.setGiftId(limited.getId());
                limitGiftData.setNum(limited.getCount());
                limitGiftData.setEndTime(limited.getExpireTime());
                builder.addList(limitGiftData.build());
            }
        });

        contextManager.write(rid, CmdCode._13060, builder.build());
    }

    protected boolean isOpen(long rid) {
        COpenCondition condition = openConditionSysCache.getCondition(EntryType.ACT_LIMIT_GIFT);
        if (roleService.getOrThrow(rid).getLevel() < condition.getCondition_value()) {
            return false;
        }
        return true;
    }

    @Subscribe
    public void getHero(HeroGetEvent event) {
        tryAddCount(event.getRid(), event.getHeros());
    }

    @Subscribe
    public void getHero(HeroStarUpEvent event) {
        tryAddCount(event.getHero().getRid(), Arrays.asList(event.getHero()));
    }


    private void tryAddCount(long rid, List<Hero> addHeros) {
        if (!isOpen(rid)) {
            return;
        }

        int now = DateTimeUtil.currentSecond();
        boolean update = false;

        int openDays = serverParamService.getOpenDays();

        for (Hero hero : addHeros) {
            List<CPromotionLimitedSet> configs = promotionLimitedSetSysCache.getByStar(hero.getStar());
            if (CollectionUtil.isNotEmpty(configs)) {
                for (CPromotionLimitedSet config : configs) {
                    CPromotionLimitedSetDay limitNumConfig = promotionLimitedSetDaySysCache.getByTypeAndOpenDays(config.getIdx(), openDays);
                    Asserts.notNull(limitNumConfig, String.format("配置不存在：%s-%s", config.getIdx(), openDays));
                    LimitProduction entity = load(rid, config.getIdx());
                    if (entity.getBuyCount() >= limitNumConfig.getBuy_max_num()) {
                        continue;//购买数量超过上限，不增加可购买数量
                    }
                    update = true;
                    entity.setCount(Math.min(entity.getCount() + 1, limitNumConfig.getShow_max_num()));
                    entity.setExpireTime(now + config.getLast_time());
                    limitProductionDao.update(entity);
                }
            }
        }
        if (update) {
            sendData(rid);
        }
    }


    protected LimitProduction load(long rid, int idx) {
        LimitProduction entity = get(rid, idx);
        if (entity == null) {
            entity = new LimitProduction();
            entity.setRid(rid);
            entity.setBuyGemIdx(idx);
            entity.setBuyTime(LocalDate.now());
            limitProductionDao.add(entity);
        } else {
            if (entity.getBuyTime() == null || !LocalDate.now().isEqual(entity.getBuyTime())) {
                entity.setBuyTime(LocalDate.now());
                entity.setBuyCount(0);
                limitProductionDao.update(entity);
            }
            if (TimeDateUtil.getCurrentTimeInt() > entity.getExpireTime()) {
                entity.setCount(0);
                limitProductionDao.update(entity);
            }

        }
        return entity;
    }


    protected LimitProduction updateCount(long rid, int now, int idx, int lastTime) {
        LimitProduction entity = load(rid, idx);
        if (entity.getExpireTime() > now) {
            entity.setCount(entity.getCount() + 1);
        } else {
            entity.setCount(1);
        }
        entity.setExpireTime(now + lastTime);
        limitProductionDao.update(entity);
        return entity;
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.HERO_STAR_GIFT;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        List<LimitProduction> all = getAll(rid);
        CBuyGem config = buyGemSysCache.getOrThrow(productId);
        LimitProduction limit = all.stream().filter(entity -> entity.getBuyGemIdx() == config.getIdx()
                && entity.getExpireTime() >= TimeDateUtil.getCurrentTimeInt()).findFirst().orElse(null);
        if (limit == null)
            return false;
        return limit.getCount() > 0;
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        List<LimitProduction> all = getAll(rid);
        LimitProduction limit = all.stream().filter(entity -> entity.getBuyGemIdx() == cBuyGem.getIdx()).findFirst().orElse(null);
        limit.setCount(limit.getCount() - 1);
        limit.setBuyCount(limit.getBuyCount() + 1);
        limitProductionDao.update(limit);
        if (isGm) {
            thingService.add(rid, cBuyGem.getItem(), GameEvent.GM_RECHARGE);
        } else {
            thingService.add(rid, cBuyGem.getItem(), GameEvent.LIMITED_PRODUCTION);
        }
    }
}
