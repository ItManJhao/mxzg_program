package com.ayjs.mxzg.gameserver.module.promotionNew.service;


import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.module.blessingPool.event.BlessingPoolDoneEvent;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion037WishTimesDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion037WishTimes;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion037WishTimesConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Objects;

@Service
@Observer
@Slf4j
public class Promotion037WishTimesService extends BasePromotionService<Promotion037WishTimes> {

    @Autowired
    private Promotion037WishTimesDao promotion037WishTimesDao;
    @Autowired
    private MailService mailService;
    @Autowired
    private LanguageSysCache languageSysCache;


    @Override
    protected void resetOnNewTurns(Promotion037WishTimes promotion, PromotionControl control) {
        promotion.getRewardList().clear();
        promotion.setRound(0);
        promotion.setTimes(0);
    }

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.XU_YUAN_DA_BIAO;
    }

    @Override
    public IRepository<Promotion037WishTimes> getRepository() {
        return promotion037WishTimesDao;
    }

    /**
     * 活动结束邮件补发
     *
     * @param control
     */
    @Override
    public void handleOnPromotionClear(PromotionControl control) {
        List<Mail> mailList = new ArrayList<>();
        List<Promotion037WishTimes> promotion037WishTimesList = getAllPromotionInfo();

        Collection<Promotion037WishTimesConfig> configList = selectConfigList();
        if (Objects.isNull(configList) || configList.size() == 0) {
            return;
        }

        promotion037WishTimesList.forEach(times -> {
            configList.stream().filter(config -> !times.getRewardList().contains(config.getIdx()) &&
                    times.getTimes() >= config.getTimes()).forEach(config -> {
                Mail mail = mailService.newMailNoTitle(times.getRid(), MailScene.XU_YUAN_DA_BIAO,
                        null, ImmutableThingUtil.fromJson(config.getReward()), GameEvent.WISH_TIMES);
                mailList.add(mail);
            });
        });
        if (mailList.size() > 0)
            mailService.insertMails(mailList);
    }

    /**
     * 监听许愿池事件
     */
    @Subscribe
    public void updatePromotionProgress(BlessingPoolDoneEvent event) {
        if (promotionControlService.isPromotionRecording(thisPromotionType())) {
            Promotion037WishTimes promotion037WishTimes = getPromotionInfo(event.getRid());
            promotion037WishTimes.setTimes(promotion037WishTimes.getTimes() + event.getCount());
            promotion037WishTimesDao.update(promotion037WishTimes);
        }
    }

    /**
     * 获取所有配置信息
     *
     * @return
     */
    public Collection<Promotion037WishTimesConfig> selectConfigList() {
        return promotionControlService.getControl(thisPromotionType()).getAllConfig(Promotion037WishTimesConfig.class);
    }


    /**
     * 获取活动单条配置
     *
     * @param idx
     * @return
     */
    public Promotion037WishTimesConfig selectConfigOne(int idx) {
        return promotionControlService.getControl(thisPromotionType()).getConfig(idx, Promotion037WishTimesConfig.class);
    }

}
