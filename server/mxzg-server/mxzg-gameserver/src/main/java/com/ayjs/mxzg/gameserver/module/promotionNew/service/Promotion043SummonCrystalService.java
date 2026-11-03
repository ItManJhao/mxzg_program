package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroGetEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroStarUpEvent;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion043SummonCrystalDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion043SummonCrystal;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion043SummonCrystalConfig;
import com.ayjs.mxzg.protocol.Promotion043GMsg;
import com.ayjs.mxzg.protocol.TaskObjGMsg;

@Service
@Observer
public class Promotion043SummonCrystalService extends BasePromotionService<Promotion043SummonCrystal> {

    @Autowired
    private Promotion043SummonCrystalDao promotion043SummonCrystalDao;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private MailService mailService;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.ZHAO_HUAN_SHUI_JING;
    }

    @Override
    protected void resetOnNewTurns(Promotion043SummonCrystal promotion, PromotionControl control) {
        promotion.setProgressMap(new HashMap<>());
        promotion.getRewardList().clear();
    }

    @Override
    public IRepository<Promotion043SummonCrystal> getRepository() {
        return promotion043SummonCrystalDao;
    }

    /**
     * 活动过期邮件补发
     *
     * @param control
     */
    @Override
    public void handleOnPromotionClear(PromotionControl control) {
        List<Mail> mailList = new ArrayList<>();
        List<Promotion043SummonCrystal> promotion043SummonCrystalList = getAllPromotionInfo();

        Collection<Promotion043SummonCrystalConfig> configList = selectConfigList();
        if (Objects.isNull(configList) || configList.size() == 0) {
            return;
        }

        promotion043SummonCrystalList.forEach(times -> {
            configList.stream().filter(config -> !times.getRewardList().contains(config.getIdx()) &&
                    !Objects.isNull(times.getProgressMap().get(config.getIdx())) &&
                    times.getProgressMap().get(config.getIdx()) >= config.getNum()).forEach(config -> {
                Mail mail = mailService.newMailNoTitle(times.getRid(), MailScene.ZHAO_HUAN_SHUI_JING,
                        null, ImmutableThingUtil.fromJson(config.getReward()), GameEvent.SUMMON_CRYSTAL);
                mailList.add(mail);
            });
        });
        if (!mailList.isEmpty())
            mailService.insertMails(mailList);
    }


    /**
     * 获取所有配置
     *
     * @return
     */
    public Collection<Promotion043SummonCrystalConfig> selectConfigList() {
        return promotionControlService.getControl(thisPromotionType()).getAllConfig(Promotion043SummonCrystalConfig.class);
    }


    /**
     * 获取活动单条配置
     *
     * @param idx
     * @return
     */
    public Promotion043SummonCrystalConfig getPromotion(int idx) {
        return promotionControlService.getControl(thisPromotionType()).getConfig(idx, Promotion043SummonCrystalConfig.class);
    }


    /**
     * 匹配对应的配置
     *
     * @param hero
     * @return
     */
    public Promotion043SummonCrystalConfig getPromotionConfig(Hero hero) {
    	CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getType());
        Promotion043SummonCrystalConfig config = null;
        for (Promotion043SummonCrystalConfig promotion043SummonCrystalConfig
                : selectConfigList()) {
            if (cHeroType.getElem() == promotion043SummonCrystalConfig.getElem()) {
                config = promotion043SummonCrystalConfig;
            }
        }
        return config;
    }

    /**
     * 根据添加的英雄更新任务进度
     *
     * @param event
     */
    @Subscribe
    public void heroAddUpdateProgress(HeroGetEvent event) {
        List<Hero> heroList = event.getHeros();
        if (promotionControlService.isPromotionRecording(thisPromotionType())) {
            heroList.forEach(hero -> {
                selectConfigList().forEach(config -> {
                	CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getType());
                    if (hero.getStar() == config.getStar() && cHeroType.getElem() == config.getElem()) {
                        updatePromotionProgress(hero, config);
                    }
                });
            });
        }
    }

    /**
     * 根据升星更新任务进度
     *
     * @param heroStarUpEvent
     */
    @Subscribe
    public void heroUpStarUpdateProgress(HeroStarUpEvent heroStarUpEvent) {
        Hero hero = heroStarUpEvent.getHero();
        if (promotionControlService.isPromotionRecording(thisPromotionType())) {
            selectConfigList().forEach(config -> {
            	CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getType());
                if (hero.getStar() == config.getStar() && cHeroType.getElem() == config.getElem()) {
                    updatePromotionProgress(hero, config);
                }
            });
        }
    }

    /**
     * 更新活动进度
     *
     * @param hero
     * @param config
     */
    private void updatePromotionProgress(Hero hero, Promotion043SummonCrystalConfig config) {
        Promotion043SummonCrystal promotion043SummonCrystal = getPromotionInfo(hero.getRid());
        Map<Integer, Integer> map = promotion043SummonCrystal.getProgressMap();
        int count = map.getOrDefault(config.getIdx(), 0);
        if (count < config.getNum()) {
            map.put(config.getIdx(), count + 1);
            promotion043SummonCrystal.setProgressMap(map);
            promotion043SummonCrystalDao.update(promotion043SummonCrystal);
            getPromotionProgress(hero.getRid());
        }
    }

    /**
     * 获取活动列表
     *
     * @param rid
     */
    public void getPromotionProgress(long rid) {
        Promotion043GMsg.GResSummonCrystalInfo.Builder builder = Promotion043GMsg.GResSummonCrystalInfo.newBuilder();
        //获取活动时间
        PromotionControl promotionControl =
                promotionControlService.getControl(PromotionType.ZHAO_HUAN_SHUI_JING);
        //获取玩家活动进度
        Promotion043SummonCrystal promotion043SummonCrystal = getPromotionInfo(rid);

        List<Integer> rewardList = promotion043SummonCrystal.getRewardList();
        promotion043SummonCrystal.getProgressMap().forEach((k, v) -> {
            TaskObjGMsg.PSSummonCrystalData.Builder data = TaskObjGMsg.PSSummonCrystalData.newBuilder();
            data.setIdx(k);
            data.setProgress(v);
            if (rewardList.contains(k)) {
                data.setIsBought(1);
            } else {
                data.setIsBought(0);
            }
            builder.addList(data);
        });
        contextManager.write(rid, CmdCode._13087, builder.build());
    }
}
