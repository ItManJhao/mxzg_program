package com.ayjs.mxzg.gameserver.module.firstRecharge.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion001FirstRechargeRewardSysCache;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.firstRecharge.dao.FirstRechargeDao;
import com.ayjs.mxzg.gameserver.module.firstRecharge.domain.FirstRecharge;
import com.ayjs.mxzg.gameserver.module.recharge.domain.RoleRecharge;
import com.ayjs.mxzg.gameserver.module.recharge.event.RechargeEvent;
import com.ayjs.mxzg.gameserver.module.recharge.service.RoleRechargeService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 首充礼包
 *
 * @description:
 * @author: CWJ
 * @date: 2019/10/15 19:47
 */
@Service
@Observer
public class FirstRechargeService {

    @Autowired
    FirstRechargeDao firstRechargeDao;
    @Autowired
    Promotion001FirstRechargeRewardSysCache promotion001FirstRechargeRewardSysCache;
    @Autowired
    RoleRechargeService roleRechargeService;
    @Autowired
    ContextManager contextManager;
    @Autowired
    ThingService thingService;
    @Autowired
    RoleService roleService;

    public FirstRecharge get(long rid) {
        FirstRecharge firstRecharge = firstRechargeDao.get(rid);
        if (firstRecharge == null) {
            firstRecharge = new FirstRecharge();
            firstRecharge.setRid(rid);
            firstRechargeDao.add(firstRecharge);
        }
        return firstRecharge;
    }

    public void update(FirstRecharge entity) {
        firstRechargeDao.update(entity);
    }

    @Subscribe
    public void recharge(RechargeEvent event) {
        FirstRecharge entity = get(event.getRid());
        RoleRecharge roleRecharge = roleRechargeService.getRoleRecharge(event.getRid());
//        entity.setMoney(entity.getMoney() + entity.getMoney());
        int now = DateTimeUtil.dayBreak();
        promotion001FirstRechargeRewardSysCache.getAll().forEach(config -> {
            if (config.getRmb() <= roleRecharge.getTotalRecharge() && !entity.getActiveTimeMap().containsKey(config.getIdx())) {
                entity.getActiveTimeMap().put(config.getIdx(), now);
            }
        });
        update(entity);

	}
}
