package com.ayjs.mxzg.gameserver.module.promotionNew.promotion092.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion092.Promotion092CountRankRewardSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion092.CPromotion092CountRankReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.mail.struct.MailParams;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion092.dao.Promotion092Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion092.domain.Promotion092;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.BasePromotionService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion092Config;
import com.ayjs.mxzg.message.module.promotion092.message.Promotion092CountRankSettleReqMessage;
import com.ayjs.mxzg.message.module.promotion092.message.Promotion092CountRankSettleResMessage;
import com.ayjs.mxzg.message.module.promotion092.message.Promotion092StatusReqMessage;
import com.ayjs.mxzg.message.module.promotion092.struct.Promotion092Data;
import com.ayjs.mxzg.message.module.promotion092.struct.Promotion092HeroData;
import com.ayjs.mxzg.template.scheduler.service.SchedulerService;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/10/21
 **/
@Service
@Slf4j
public class Promotion092Service extends BasePromotionService<Promotion092> {
    @Autowired
    private Promotion092Dao promotion092Dao;
    @Autowired
    private DeliverCountRankService deliverCountRankService;
    @Autowired
    private HeroScoreRankService heroScoreRankService;
    @Autowired
    private MailService mailService;
    @Autowired
    private Promotion092CountRankRewardSysCache promotion092CountRankRewardSysCache;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private RoleService roleService;
    @Autowired
    private SchedulerService schedulerService;

    private ScheduledFuture future;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.NV_SHEN_XIAN_HUA;
    }

    @Override
    public IRepository<Promotion092> getRepository() {
        return promotion092Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion092 promotion, PromotionControl control) {
        promotion.getDeliverData().clear();
        promotion.setCount(0);
        promotion.getCountRewardRecord().clear();
        promotion.setBuyCount(0);

    }

    @Override
    public void handleOnPromotionNewTurns(PromotionControl control) {
        deliverCountRankService.clear();
        heroScoreRankService.clear();
        messageDispatcher.dispatch(Promotion092StatusReqMessage.of(Arrays.asList(serverConfig.getSubServerIds()), control.getStatus(),
                control.getStartTime()));
    }

    @Override
    public void handleOnPromotionClear(PromotionControl control) {
        log.info("正在进行活动{}的结算处理", thisPromotionType());
        requestCross(control);
    }

    public void requestCross(PromotionControl control) {
        messageDispatcher.dispatch(Promotion092CountRankSettleReqMessage.of(serverConfig.getServerId(), control.getStartTime()),
                (res) -> mailRank((Promotion092CountRankSettleResMessage) res));
        messageDispatcher.dispatch(Promotion092StatusReqMessage.of(Arrays.asList(serverConfig.getSubServerIds()), control.getStatus(),
                control.getStartTime()));
        future = schedulerService.schedule("promotion092 scheduler reward", () -> requestCross(control), 2, TimeUnit.MINUTES);
    }

    public void mailRank(Promotion092CountRankSettleResMessage res) {
        if (future != null) {
            future.cancel(true);
            future = null;
        }

        PromotionControl controller = promotionControlService.getControl(thisPromotionType());
        if (controller.getExtraInfo().equals(controller.getStartTime() + "")) {
            return;
        }
        controller.setExtraInfo(controller.getStartTime() + "");
        promotionControlService.updateControl(controller);

        log.info(GsonUtils.toJson(res));
        mail(res.getRankDataList());
        mailHero(res.getHeroRankDataList());


    }

    private void mailHero(List<Promotion092HeroData> ranks) {
        List<Mail> mailList = new ArrayList<>();
        if (ranks == null || ranks.size() <= 0) {
            return;
        }
        Promotion092HeroData rank = ranks.get(0);
        try {
            List<Promotion092> promotions = getAllPromotionInfo().stream().filter(promotion -> promotion.getCount() > 0).collect(Collectors.toList());
            promotions.forEach(promotion092 -> {
                ImmutableThing reward = ImmutableThing.of(heroTypeSysCache.getById(rank.getHeroType()).getItem_id(),
                        getConfig().getHero_rank_reward());
                Mail mail = mailService.newSimpleMail(promotion092.getRid(), MailScene.PROMOTION_092_HERO_SCORE_RANK,
                        Arrays.asList(reward), GameEvent.PROMOTION_092_HERO_SCORE_RANK);
                mailList.add(mail);
            });
        } catch (Exception e) {
            log.error(String.format("发送排名奖励异常：{%s},排名{%s}", GsonUtils.toJson(rank)));
        }
        mailService.insertMails(mailList);
        log.info("正在进行活动{}的结算处理，发放邮件{}封", thisPromotionType(), mailList.size());
    }

    private void mail(List<Promotion092Data> ranks) {
        List<Mail> mailList = new ArrayList<>();
        if (ranks == null || ranks.size() <= 0) {
            return;
        }
        for (int i = 0; i < ranks.size(); i++) {
            Promotion092Data rank = ranks.get(i);
            if (!roleService.isRole(rank.getRankId())) {
                continue;
            }
            try {
                CPromotion092CountRankReward config = promotion092CountRankRewardSysCache.getByRank(rank.getRank());
                if (config != null) {
                    Mail mail = mailService.newMailNoTitle(rank.getRankId(), MailScene.PROMOTION_092_COUNT_RANK, MailParams.build(i + 1),
                            config.getReward(), GameEvent.PROMOTION_092_DELIVER_COUNT_RANK);
                    mailList.add(mail);
                }
            } catch (Exception e) {
                log.error(String.format("发送排名奖励异常：{%s},排名{%s}", GsonUtils.toJson(rank), i + 1));
            }
        }
        mailService.insertMails(mailList);
        log.info("正在进行活动{}的结算处理，发放邮件{}封", thisPromotionType(), mailList.size());
    }

    public boolean isOpen() {
        return promotionControlService.isPromotionRunning(thisPromotionType());
    }

    public Promotion092Config getConfig() {
        PromotionControl promotionControl = promotionControlService.getControl(thisPromotionType());
        return promotionControl.getConfig(1, Promotion092Config.class);
    }


}
