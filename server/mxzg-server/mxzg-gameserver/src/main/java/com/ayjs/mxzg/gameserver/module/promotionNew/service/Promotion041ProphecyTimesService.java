package com.ayjs.mxzg.gameserver.module.promotionNew.service;


import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion041ProphecyTimesDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion041ProphecyTimes;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.prophetSummon.event.ProphetSummonEvent;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion041ProphecyTimesConfig;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion041GMsg;
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
public class Promotion041ProphecyTimesService extends BasePromotionService<Promotion041ProphecyTimes> {

    @Autowired
    private Promotion041ProphecyTimesDao promotion041ProphecyTimesDao;
    @Autowired
    private MailService mailService;
    @Autowired
    private ContextManager contextManager;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.XIAN_ZHI_KUI_ZENG;
    }

    @Override
    protected void resetOnNewTurns(Promotion041ProphecyTimes promotion, PromotionControl control) {
        promotion.setTimes(0);
        promotion.getRewardIdx().clear();
        promotion.setRound(0);
    }

    @Override
    public IRepository<Promotion041ProphecyTimes> getRepository() {
        return promotion041ProphecyTimesDao;
    }


//    public Promotion041ProphecyTimes select(long rid) {
//        return null;
//    }

    /**
     * 未领取邮件补发
     *
     * @param control
     */
    @Override
    public void handleOnPromotionClear(PromotionControl control) {
        List<Mail> mailList = new ArrayList<>();
        List<Promotion041ProphecyTimes> promotion041ProphecyTimesList = getAllPromotionInfo();

        Collection<Promotion041ProphecyTimesConfig> configList = selectConfigList();
        if (Objects.isNull(configList) || configList.size() == 0) {
            return;
        }

        promotion041ProphecyTimesList.forEach(times -> {
            configList.stream().filter(config -> !times.getRewardIdx().contains(config.getIdx()) &&
                    times.getTimes() >= config.getPlay_times()).forEach(config -> {
                Mail mail = mailService.newMailNoTitle(times.getRid(), MailScene.XIAN_ZHI_KUI_ZENG, null,
                        ImmutableThingUtil.fromJson(config.getReward()), GameEvent.PROPHECY_GIFT);
                mailList.add(mail);
            });
        });
        if (mailList.size() > 0)
            mailService.insertMails(mailList);
    }

    /**
     * 更新先知馈赠活动数据
     *
     * @param event
     */
    @Subscribe
    public void updateProphetPromotion(ProphetSummonEvent event) {
        if (promotionControlService.isPromotionRecording(thisPromotionType())) {
            Promotion041ProphecyTimes promotion041ProphecyTimes = getPromotionInfo(event.getRid());
            promotion041ProphecyTimes.setTimes(promotion041ProphecyTimes.getTimes() + 1);
            promotion041ProphecyTimesDao.update(promotion041ProphecyTimes);
            getPromotion041ProphecyGiftList(event.getRid());
        }
    }

    /**
     * 获取活动所有配置信息
     */
    public Collection<Promotion041ProphecyTimesConfig> selectConfigList() {
        return promotionControlService.getControl(thisPromotionType()).getAllConfig(Promotion041ProphecyTimesConfig.class);
    }

    /**
     * 获取活动单条配置
     *
     * @param idx
     * @return
     */
    public Promotion041ProphecyTimesConfig selectConfigOne(int idx) {
        return promotionControlService.getControl(thisPromotionType()).getConfig(idx, Promotion041ProphecyTimesConfig.class);
    }

    @Override
    public String getConfigStr() {
        return JsonUtil.toJson(selectConfigList());
    }

    /**
     * 获取先知馈赠列表
     *
     * @param rid
     */
    public void getPromotion041ProphecyGiftList(long rid) {
        Promotion041GMsg.GResProphecyList.Builder builder = Promotion041GMsg.GResProphecyList.newBuilder();

        Promotion041ProphecyTimes prophecyGift = getPromotionInfo(rid);
        builder.setNvalue(prophecyGift.getTimes());
        builder.setRound(prophecyGift.getRound());

        Collection<Promotion041ProphecyTimesConfig> configList = selectConfigList();
        configList.forEach(config -> {
            ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
            data.setKey(config.getIdx());
            if (prophecyGift.getRewardIdx().contains(config.getIdx())) {
                data.setValue(1);
            } else {
                data.setValue(0);
            }
            builder.addList(data);
        });

        contextManager.write(rid, CmdCode._13076, builder.build());
    }
}
