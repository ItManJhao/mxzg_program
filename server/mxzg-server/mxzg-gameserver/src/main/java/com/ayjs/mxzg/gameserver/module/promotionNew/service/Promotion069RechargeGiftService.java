package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeConstants;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion001FirstRechargeSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion069RechargeGiftSysCache;
import com.ayjs.mxzg.config.excel.constant.PromotionConst;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion069RechargeGift;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.firstRecharge.domain.FirstRecharge;
import com.ayjs.mxzg.gameserver.module.firstRecharge.event.FirstRechargeEvent;
import com.ayjs.mxzg.gameserver.module.firstRecharge.service.FirstRechargeService;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion069RechargeGiftDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion069RechargeGift;
import com.ayjs.mxzg.gameserver.module.recharge.event.RechargeEvent;
import com.ayjs.mxzg.gameserver.module.recharge.service.RoleRechargeService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.promotion069GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author hyx
 */
@Observer
@Service
public class Promotion069RechargeGiftService {

    @Autowired
    private Promotion069RechargeGiftDao promotion069RechargeGiftDao;
    @Autowired
    private RoleService roleService;
    @Autowired
    private RoleRechargeService roleRechargeService;
    @Autowired
    private Promotion069RechargeGiftSysCache promotion069RechargeGiftSysCache;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private Promotion001FirstRechargeSysCache promotion001FirstRechargeSysCache;
    @Autowired
    private FirstRechargeService firstRechargeService;

    /**
     * @return
     */
    public Promotion069RechargeGift get(long rid) {
        Promotion069RechargeGift promotion069RechargeGift = promotion069RechargeGiftDao.get(rid);
        if (promotion069RechargeGift == null) {
            promotion069RechargeGift = new Promotion069RechargeGift();
            promotion069RechargeGift.setRid(rid);
            promotion069RechargeGiftDao.add(promotion069RechargeGift);
            //旧数据处理
            FirstRecharge firstRecharge = firstRechargeService.get(rid);
            if (firstRecharge.getRewards().size() == promotion001FirstRechargeSysCache.getAll().size()) {
                this.activePromotion(promotion069RechargeGift);
            }
        }
        return promotion069RechargeGift;
    }

    public void update(Promotion069RechargeGift promotion069RechargeGift) {
        promotion069RechargeGiftDao.update(promotion069RechargeGift);
    }

    /**
     * 发送活动数据
     *
     * @param promotion069RechargeGift
     */
    public void sendInfo(Promotion069RechargeGift promotion069RechargeGift) {
        promotion069GMsg.GResRechargeGiftInfo.Builder builder = promotion069GMsg.GResRechargeGiftInfo.newBuilder();
        builder.setOpenTime(promotion069RechargeGift.getOpenTime());
        builder.setRecharge(promotion069RechargeGift.getRecharge());

        for (Map.Entry<Integer, Integer> entry : promotion069RechargeGift.getActiveTimeMap().entrySet()) {
            List<CPromotion069RechargeGift> configList = promotion069RechargeGiftSysCache.getConfigList(entry.getKey());
            //当前档次最多领取天数
            int maxDay = promotion069RechargeGiftSysCache.getDay(entry.getKey());
            //已激活天数
            int day = DateTimeUtil.apartDay(DateTimeUtil.currentSecond(), entry.getValue()) + 1;
            //已领取的奖励
            List<Integer> rewardList = new ArrayList<>();
            for (CPromotion069RechargeGift config : configList) {
                promotion069GMsg.PSGetRewardInfo.Builder data = promotion069GMsg.PSGetRewardInfo.newBuilder();
                data.setIdx(config.getIdx());
                if (config.getReward_type() == 0) {
                    //在限定时间内可以每天领取一次
                    int time = promotion069RechargeGift.getRewardTimeMap().getOrDefault(config.getIdx(), 0);
                    data.setStatus(time < DateTimeUtil.dayBreak() && day <= maxDay ? 0 : 1);
                    if (data.getStatus() == 1) {
                        rewardList.add(config.getIdx());
                    }
                } else {//status = 1表示已领取或不可领取
                    data.setStatus(!promotion069RechargeGift.getRewardList().contains(config.getIdx()) && day >= config.getNeed_day() ? 0 : 1);
                }
                if (promotion069RechargeGift.getRewardList().contains(config.getIdx())) {
                    rewardList.add(config.getIdx());
                }
                builder.addRewardList(data);
            }
            builder.addAllRewardIds(rewardList);
            //档次奖励是否已全部领取完
            promotion069GMsg.PSTypeRewardInfo.Builder data = promotion069GMsg.PSTypeRewardInfo.newBuilder();
            data.setType(entry.getKey());
            data.setStatus(day >= maxDay && rewardList.size() == configList.size() ? 1 : 0);
            builder.addTypeList(data);
        }

        contextManager.write(promotion069RechargeGift.getRid(), CmdCode._14400, builder.build());
    }


    @Subscribe
    public void listen(RechargeEvent event) {
        Promotion069RechargeGift promotion069RechargeGift = this.get(event.getRid());
        //记录活动期间充值金额
        if (promotion069RechargeGift.getOpenTime() <= DateTimeUtil.currentSecond()) {

            promotion069RechargeGift.setRecharge(promotion069RechargeGift.getRecharge() + event.getMoney());
            for (Integer type : promotion069RechargeGiftSysCache.getRechargeMap().keySet()) {
                if (promotion069RechargeGift.getActiveTimeMap().get(type) == null &&
                        promotion069RechargeGift.getRecharge() >= promotion069RechargeGiftSysCache.getRecharge(type)) {
                    promotion069RechargeGift.getActiveTimeMap().put(type, DateTimeUtil.dayBreak());
                }
            }
            this.update(promotion069RechargeGift);
            //更新前端数据
            this.sendInfo(promotion069RechargeGift);
        }
    }

    @Subscribe
    public void listen(FirstRechargeEvent event) {
        FirstRecharge firstRecharge = firstRechargeService.get(event.getRid());
        if (firstRecharge.getRewards().size() == promotion001FirstRechargeSysCache.getAll().size()) {
            Promotion069RechargeGift promotion069RechargeGift = this.get(event.getRid());

            this.activePromotion(promotion069RechargeGift);
            //更新前端数据
            this.sendInfo(promotion069RechargeGift);
        }
    }

    private void activePromotion(Promotion069RechargeGift promotion069RechargeGift) {
        Role role = roleService.getOrThrow(promotion069RechargeGift.getRid());
        int openTime = DateTimeUtil.theDayBreak((int) (role.getCreateTime() / TimeConstants.ONE_SECOND_MILLIS)) + PromotionConst.RECHARGE_GIFT_START_TIME * TimeConstants.ONE_DAY_SECOND;
        promotion069RechargeGift.setOpenTime(openTime);
        this.update(promotion069RechargeGift);
    }

}
