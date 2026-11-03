package com.ayjs.mxzg.gameserver.module.promotionNew.service;

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
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion048WeeklyRechargeDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion048WeeklyRecharge;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.recharge.event.RechargeEvent;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion048WeeklyRechargeConfig;
import com.ayjs.mxzg.protocol.Promotion048GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 运营累计充值活动
 *
 * @Author: CWJ
 * @Date: 2019/10/22
 **/
@Service
@Observer
public class Promotion048WeeklyRechargeService extends BasePromotionService<Promotion048WeeklyRecharge> {
    @Autowired
    private Promotion048WeeklyRechargeDao promotion048WeeklyRechargeDao;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private MailService mailService;
    @Autowired
    private ContextManager contextManager;


    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.MEI_ZHOU_LEI_CHONG;
    }

    @Override
    public IRepository<Promotion048WeeklyRecharge> getRepository() {
        return promotion048WeeklyRechargeDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion048WeeklyRecharge promotion, PromotionControl control) {
        promotion.setRecharge(0);
        promotion.getRewardIdx().clear();
    }

    @Override
    public void handleOnPromotionClear(PromotionControl control) {
        List<Promotion048WeeklyRecharge> promotion048WeeklyRecharges = promotion048WeeklyRechargeDao.listAll().stream()
                .filter(promotion -> promotion.getRecharge() > 0).collect(Collectors.toList());
        List<Mail> mails = new ArrayList<>();
        promotion048WeeklyRecharges.forEach(promotion -> {
            List<Promotion048WeeklyRechargeConfig> rewardConfigs = new ArrayList<>();
            getAllConfig().forEach(config -> {
                if (config.getRmb() <= promotion.getRecharge() && !promotion.getRewardIdx().contains(config.getIdx())) {
                    rewardConfigs.add(config);
                    promotion.getRewardIdx().add(config.getIdx());
                }
            });
            if (rewardConfigs.size() > 0) {
                updatePromotion(promotion);
                List<ImmutableThing> rewards = rewardConfigs.stream().map(Promotion048WeeklyRechargeConfig::getRewardThings)
                        .flatMap(Collection::stream).collect(Collectors.toList());
                Mail mail = mailService.newSimpleMail(promotion.getRid(), MailScene.PROMOTION_048, ImmutableThingUtil.mergeThing(rewards), GameEvent.WEEKLY_RECHARGE);
                mails.add(mail);
            }
        });
        if (mails.size() > 0) {
            mailService.insertMails(mails);
        }
    }

    @Subscribe
    public void recharge(RechargeEvent event) {
        if (!promotionControlService.isPromotionRunning(thisPromotionType())) {
            return;
        }
        Promotion048WeeklyRecharge promotionInfo = getPromotionInfo(event.getRid());
        promotionInfo.setRecharge(promotionInfo.getRecharge() + event.getMoney());
        updatePromotion(promotionInfo);
        contextManager.write(event.getRid(), CmdCode._13015, sendData(event.getRid()));
    }

    public Promotion048GMsg.GResRechargeWeekList sendData(long rid) {
        Promotion048GMsg.GResRechargeWeekList.Builder builder = Promotion048GMsg.GResRechargeWeekList.newBuilder();
        Promotion048WeeklyRecharge promotion = getPromotionInfo(rid);
        builder.setCompleted(promotion.getRecharge());
        promotion.getRewardIdx().forEach(idx -> {
            Promotion048GMsg.ResPromotionRewardData.Builder data = Promotion048GMsg.ResPromotionRewardData.newBuilder();
            data.setIndex(idx);
            data.setIsReward(1);
            builder.addList(data);
        });
        return builder.build();
    }

    public Collection<Promotion048WeeklyRechargeConfig> getAllConfig() {
        PromotionControl control = promotionControlService.getControl(thisPromotionType());
        return control.getAllConfig(Promotion048WeeklyRechargeConfig.class);
    }

    public Promotion048WeeklyRechargeConfig getConfig(int idx) {
        PromotionControl control = promotionControlService.getControl(thisPromotionType());
        return control.getConfig(idx, Promotion048WeeklyRechargeConfig.class);
    }

}
