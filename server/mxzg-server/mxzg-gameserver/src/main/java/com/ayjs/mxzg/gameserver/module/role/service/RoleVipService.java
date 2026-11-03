package com.ayjs.mxzg.gameserver.module.role.service;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.config.excel.cache.GoddessVipSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopcontrolSysCache;
import com.ayjs.mxzg.config.excel.constant.IdleConst;
import com.ayjs.mxzg.config.excel.constant.TavernConst;
import com.ayjs.mxzg.config.excel.entity.CGoddessVip;
import com.ayjs.mxzg.config.excel.entity.shop.CShopcontrol;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.shop.constant.ShopType;

@Service
public class RoleVipService {

    @Autowired
    private ShopcontrolSysCache shopcontrolSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private GoddessVipSysCache goddessVipSysCache;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private PromotionControlService promotionControlService;

    /**
     * 获取商店刷新最大次数
     *
     * @param rid
     * @param shopType
     * @return
     */
    public int getShopMaxRefreshNum(long rid, int shopType) {
        int maxRefreshNum = 0;
        // 获取配置表次数
        CShopcontrol cShopcontrol = shopcontrolSysCache.getOrThrow(shopType);
        maxRefreshNum = cShopcontrol.getDaily_free_refresh() + cShopcontrol.getDaily_charge_refresh();
        // 拿vip加成次数
        if (shopType == ShopType.MARKET.getValue()) {
            Role role = roleService.getOrThrow(rid);
            CGoddessVip cGoddessVip = goddessVipSysCache.getOrThrow(role.getGoddessVip());
            maxRefreshNum += cGoddessVip.getExtra_market_times();
        }
        return maxRefreshNum;
    }

    /**
     * 获取英雄容量
     *
     * @param rid
     * @return
     */
    public int getHeroCapacity(long rid) {

        Role role = roleService.getOrThrow(rid);
        int vipBagSpace = 0;
        if (role.getGoddessVip() > 0) {
            CGoddessVip goddessVip = goddessVipSysCache.getOrThrow(role.getGoddessVip());
            vipBagSpace = goddessVip.getExtra_bag_space();
        }

        return vipBagSpace + role.getHeroNum();
    }

    /**
     * 获取最大挂机时长
     *
     * @param rid
     */
    public int getIdleMaxTime(long rid) {
        Role role = roleService.getOrThrow(rid);
        // 获取VIP等级
        int vipIdleTime = 0;
        if (role.getGoddessVip() > 0) {
            CGoddessVip cvip = goddessVipSysCache.getOrThrow(role.getGoddessVip());
            vipIdleTime = cvip.getExtra_idle_time();
        }
        //秒
        return IdleConst.MAX_TIME + vipIdleTime;
    }

    /**
     * 获取最大每日副本购买次数
     *
     * @param rid
     * @return
     */
    public int getDailyDungeonNum(long rid) {

        Role role = roleService.getOrThrow(rid);

        int vipResourceTimes = 0;
        if (role.getGoddessVip() > 0) {
            CGoddessVip goddessVip = goddessVipSysCache.getOrThrow(role.getGoddessVip());
            vipResourceTimes = goddessVip.getExtra_resource_times();
        }

        return vipResourceTimes + systemSysCache.getDailyMissionFreeTickets();
    }


   /* *//**
     * 获取可接酒馆任务数量
     *
     * @param rid
     * @return
     *//*
    public int getTaskCount(long rid) {
        Role role = roleService.getOrThrow(rid);

        // 查询当前是否有酒馆常客活动加成
        int addTaskCount = 0;
        if (promotionControlService.isPromotionRunning(PromotionType.JIU_GUAN_CHANG_KE)) {
            // 活动增加固定值为2
            addTaskCount = TavernConst.PROMOTION_PLUS_TIMES;
        }

        // 获取vip得到任务上限
        int vipTavern = 0;
        if (role.getGoddessVip() > 0) {
            CGoddessVip cvip = goddessVipSysCache.getOrThrow(role.getGoddessVip());
            vipTavern = cvip.getTavern();
        }
        int taskCount = vipTavern + addTaskCount + TavernConst.NUM;
        return taskCount;
    }*/
}
