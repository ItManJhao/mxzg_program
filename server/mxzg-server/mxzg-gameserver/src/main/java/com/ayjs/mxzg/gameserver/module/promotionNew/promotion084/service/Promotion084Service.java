package com.ayjs.mxzg.gameserver.module.promotionNew.promotion084.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion084.converter.Promotion084PB;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion084.dao.Promotion084Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion084.domain.Promotion084;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.BasePromotionService;
import com.ayjs.mxzg.gameserver.module.recharge.event.RechargeEvent;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion084ThreeDayConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Slf4j
@Service
@Observer
public class Promotion084Service extends BasePromotionService<Promotion084> {

    @Autowired
    private Promotion084Dao promotion084Dao;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private Promotion084PB promotion084PB;
    @Autowired
    private MailService mailService;

    @Override
    public Promotion084 getPromotionInfo(long rid) {
        Promotion084 promotionInfo = super.getPromotionInfo(rid);
        if (!LocalDate.now().isEqual(promotionInfo.getRechargeRefresh())) {
            if (getConfig(promotionInfo.getCurrDay()).getRmb() <= promotionInfo.getRechargeInfo().getOrDefault(promotionInfo.getCurrDay(), 0l)) {
                if (getConfig(promotionInfo.getCurrDay() + 1) != null) {
                    promotionInfo.setCurrDay(promotionInfo.getCurrDay() + 1);
                    promotionInfo.getRechargeInfo().put(promotionInfo.getCurrDay(), 0l);
                }
            } else {
                promotionInfo.getRechargeInfo().put(promotionInfo.getCurrDay(), 0l);
            }
            promotionInfo.setRechargeRefresh(LocalDate.now());
            updatePromotion(promotionInfo);
        }
        return promotionInfo;
    }

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.SAN_RI_LEI_CHONG;
    }

    @Override
    public IRepository<Promotion084> getRepository() {
        return promotion084Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion084 promotion, PromotionControl control) {
        promotion.getRewardRecord().clear();
        promotion.getRechargeInfo().clear();
        promotion.setCurrDay(1);
        promotion.setRechargeRefresh(LocalDate.now());
    }

    @Override
    public void handleOnPromotionClear(PromotionControl control) {
        List<Mail> mails = new ArrayList<>();
        getAllPromotionInfo().forEach(promotion084 -> {
            List<ImmutableThing> rewards = new ArrayList<>();
            promotion084.getRechargeInfo().forEach((key, value) -> {
                if (!promotion084.getRewardRecord().contains(key)) {
                    Promotion084ThreeDayConfig config = getConfig(key);
                    if (config.getRmb() <= value) {
                        rewards.addAll(config.getRewardThings());
                        promotion084.getRewardRecord().add(key);
                        updatePromotion(promotion084);
                    }
                }
            });
            if (rewards.size() != 0) {
                Mail mail = mailService.newSimpleMail(promotion084.getRid(), MailScene.PROMOTION_084,
                        ImmutableThingUtil.mergeThing(rewards), GameEvent.PROMOTION_084_GET_REWARD);
                mails.add(mail);
            }
        });
        mailService.insertMails(mails);
    }

    public boolean isOpening() {
        return promotionControlService.isPromotionRunning(thisPromotionType());
    }

    public Collection<Promotion084ThreeDayConfig> getAllConfig() {
        return promotionControlService.getControl(thisPromotionType()).getAllConfig(Promotion084ThreeDayConfig.class);
    }

    public Promotion084ThreeDayConfig getConfig(int idx) {
        return promotionControlService.getControl(thisPromotionType()).getConfig(idx, Promotion084ThreeDayConfig.class);
    }

    @Subscribe
    public void listen(RechargeEvent event) {
        if (!isOpening()) {
            return;
        }
        Promotion084 promotionInfo = getPromotionInfo(event.getRid());
        long currValue = promotionInfo.getRechargeInfo().getOrDefault(promotionInfo.getCurrDay(), 0l);
        promotionInfo.getRechargeInfo().put(promotionInfo.getCurrDay(), currValue + event.getMoney());
        updatePromotion(promotionInfo);
        contextManager.write(event.getRid(), CmdCode._76062, promotion084PB.buildUpdateRecharge(promotionInfo));
    }
}
