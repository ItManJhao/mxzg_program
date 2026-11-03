package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroSummonEvent;
import com.ayjs.mxzg.gameserver.module.hero.struct.SummonType;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion040SummonTimesDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion040SummonTimes;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion040SummonTimesConfig;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion040GMsg;
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
public class Promotion040SummonTimesService extends BasePromotionService<Promotion040SummonTimes> {

    @Autowired
    private Promotion040SummonTimesDao promotion040SummonTimesDao;

    @Autowired
    private MailService mailService;
    @Autowired
    private ContextManager contextManager;

    @Override
    public IRepository<Promotion040SummonTimes> getRepository() {
        return promotion040SummonTimesDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion040SummonTimes promotion, PromotionControl control) {
        promotion.getRewardList().clear();
        promotion.setRound(0);
        promotion.setTimes(0);
    }

    /**
     * 活动束结邮件补发
     *
     * @param control
     */
    @Override
    public void handleOnPromotionClear(PromotionControl control) {
        List<Mail> mailList = new ArrayList<>();
        List<Promotion040SummonTimes> promotion040SummonTimesList = getAllPromotionInfo();

        Collection<Promotion040SummonTimesConfig> configList = selectConfigList();
        if (Objects.isNull(configList) || configList.size() == 0) {
            return;
        }

        promotion040SummonTimesList.forEach(times -> {
            configList.stream().filter(config -> !times.getRewardList().contains(config.getIdx()) &&
                    times.getTimes() >= config.getSummon_times()).forEach(config -> {
                Mail mail = mailService.newMailNoTitle(times.getRid(), MailScene.ZHAO_HUAN_DA_BIAO,
                        null, ImmutableThingUtil.fromJson(config.getReward()), GameEvent.SUMMON_TIMES);
                mailList.add(mail);
            });
        });
        if (mailList.size() > 0)
            mailService.insertMails(mailList);
    }

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.ZHAO_HUAN_DA_BIAO;
    }

    /**
     * 英雄召唤监听
     *
     * @param event
     */
    @Subscribe
    public void updatePromotionProgress(HeroSummonEvent event) {
        Promotion040SummonTimes promotion040SummonTimes = getPromotionInfo(event.getRid());
        if (event.getType() == SummonType.HIGH && promotionControlService.isPromotionRecording(thisPromotionType())) {
            promotion040SummonTimes.setTimes(promotion040SummonTimes.getTimes() + event.getSummonCount());
            promotion040SummonTimesDao.update(promotion040SummonTimes);
            getPromotionProgress(event.getRid());
        }
    }

    /**
     * 发送召唤达标列表
     *
     * @param rid
     */
    public void getPromotionProgress(long rid) {
        Promotion040GMsg.GResSummonList.Builder builder = Promotion040GMsg.GResSummonList.newBuilder();

        PromotionControl control = promotionControlService.getControl(PromotionType.ZHAO_HUAN_DA_BIAO);

        Promotion040SummonTimes promotion040SummonTimes = getPromotionInfo(rid);
        builder.setNvalue(promotion040SummonTimes.getTimes());
        builder.setRound(promotion040SummonTimes.getRound());

        Collection<Promotion040SummonTimesConfig> configList = selectConfigList();
        configList.forEach(config -> {
            ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
            data.setKey(config.getIdx());
            if (promotion040SummonTimes.getRewardList().contains(config.getIdx())) {
                data.setValue(1);
            } else {
                data.setValue(0);
            }
            builder.addList(data);
        });

        contextManager.write(rid, CmdCode._13080, builder.build());
    }

    /**
     * 获取所有配置信息
     *
     * @return
     */
    public Collection<Promotion040SummonTimesConfig> selectConfigList() {
        return promotionControlService.getControl(thisPromotionType()).getAllConfig(Promotion040SummonTimesConfig.class);
    }


    /**
     * 获取活动单条配置
     *
     * @param idx
     * @return
     */
    public Promotion040SummonTimesConfig selectConfigOne(int idx) {
        return promotionControlService.getControl(thisPromotionType()).getConfig(idx, Promotion040SummonTimesConfig.class);
    }

}
