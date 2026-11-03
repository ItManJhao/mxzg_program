package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion045LoginGiftDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion045LoginGift;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.event.ZeroTimeEvent;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion045LoginGiftConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 登录有礼
 *
 * @Author: CWJ
 * @Date: 2019/10/22
 **/
@Service
@Observer
public class Promotion045LoginGiftService extends BasePromotionService<Promotion045LoginGift> {
    @Autowired
    private Promotion045LoginGiftDao promotion045LoginGiftDao;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    RoleService roleService;
    @Autowired
    private ContextManager contextManager;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.DENG_LU_YOU_LI;
    }

    @Override
    public IRepository<Promotion045LoginGift> getRepository() {
        return promotion045LoginGiftDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion045LoginGift promotion, PromotionControl control) {
        promotion.setLoginDays(1);
        promotion.setLastLoginTime(DateTimeUtil.currentSecond());
        promotion.getRewardRecord().clear();
    }

    @Override
    public void handleOnPromotionNewTurns(PromotionControl control) {
        contextManager.getAllOnline().forEach(playerContext -> {
            if (playerContext.getId() > 0){
                tryAddLoginDays(playerContext.getId());
            }
        });
    }

    @Subscribe
    public void login(LoginEvent event) {
        tryAddLoginDays(event.getRid());
    }

    @Subscribe
    public void zeroTime(ZeroTimeEvent event) {
        tryAddLoginDays(event.getRid());
    }

    private void tryAddLoginDays(long rid) {
        if (!promotionControlService.isPromotionRecording(thisPromotionType())) {
            return;
        }
        Promotion045LoginGift promotionInfo = getPromotionInfo(rid);
        if (TimeDateUtil.isToday(promotionInfo.getLastLoginTime())) {
            return;
        }
        promotionInfo.setLoginDays(promotionInfo.getLoginDays() + 1);
        promotionInfo.setLastLoginTime(TimeDateUtil.getCurrentTimeInt());
        updatePromotion(promotionInfo);
    }

    public Promotion045LoginGiftConfig getConfig(int idx) {
        return promotionControlService.getControl(thisPromotionType()).getConfig(idx, Promotion045LoginGiftConfig.class);
    }

}
