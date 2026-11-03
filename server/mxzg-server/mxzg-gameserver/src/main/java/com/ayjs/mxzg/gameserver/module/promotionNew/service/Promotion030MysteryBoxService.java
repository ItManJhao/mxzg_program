package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion030MysteryBoxLevelRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion030MysteryBoxRechargeRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion030MysteryBoxSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion030MysteryBox;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion030MysteryBoxLevelReward;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion030MysteryBoxRechargeReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion030MysteryBoxDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion030MysteryBox;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.targetCounter.service.TargetCounterService;
import com.ayjs.mxzg.protocol.Task4GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 神秘魔盒
 *
 * @Author: CWJ
 * @Date: 2019/10/24
 **/
@Service
public class Promotion030MysteryBoxService extends BasePromotionService<Promotion030MysteryBox> {

    @Autowired
    private Promotion030MysteryBoxDao promotion030MysteryBoxDao;
    @Autowired
    private Promotion030MysteryBoxSysCache promotion030MysteryBoxSysCache;
    @Autowired
    private Promotion030MysteryBoxRechargeRewardSysCache promotion030MysteryBoxRechargeRewardSysCache;
    @Autowired
    private Promotion030MysteryBoxLevelRewardSysCache promotion030MysteryBoxLevelRewardSysCache;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private TargetCounterService targetCounterService;
    @Autowired
    private MailService mailService;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.SHEN_MI_MO_HE;
    }

    @Override
    public IRepository<Promotion030MysteryBox> getRepository() {
        return promotion030MysteryBoxDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion030MysteryBox promotion, PromotionControl control) {
        promotion.setRecharge(0);
        promotion.getRechargeRewardRecord().clear();
        promotion.getCountMap().clear();
        promotion.setExp(0);
        promotion.getRewardRecord().clear();
        promotion.setCurrDay(0);
        promotion.setLastLoginTime(0);
    }

    @Override
    public void handleOnPromotionNewTurns(PromotionControl control) {
        int now = DateTimeUtil.currentSecond();
        List<Promotion030MysteryBox> list = getAllPromotionInfo();
        for (Promotion030MysteryBox promotionInfo : list) {
            promotionInfo.setRecharge(0);
            promotionInfo.setExp(0);
        }
        promotion030MysteryBoxDao.update(list);

        contextManager.getAllOnline().stream().filter(playerContext -> playerContext.getId() > 0).forEach(playerContext -> {
            List<CPromotion030MysteryBox> configs = getConfigsByTypeAndDays(TargetType.LOGIN);
            Promotion030MysteryBox promotionInfo = getPromotionInfo(playerContext.getId());
            if (!TimeDateUtil.isToday(promotionInfo.getLastLoginTime())) {
                promotionInfo.setLastLoginTime(now);
                updatePromotion(promotionInfo);
                configs.forEach(config -> {
                    addCount(playerContext.getId(), config, 1);
                });
            }
        });
    }

    @Override
    public Promotion030MysteryBox getPromotionInfo(long rid) {
        Promotion030MysteryBox promotionInfo = super.getPromotionInfo(rid);
        if (!promotionControlService.isPromotionRunning(thisPromotionType())) {
            return promotionInfo;
        }
        PromotionControl control = promotionControlService.getControl(thisPromotionType());
        int now = DateTimeUtil.currentSecond();
        int interDays = DateTimeUtil.apartDay(control.getStartTime(), now) + 1;
        if (interDays != promotionInfo.getCurrDay()) {
            promotionInfo.getCountMap().clear();
            getConfigByTurnsAndDay().forEach(config -> {
                //初始化所有值
                int count = targetCounterService.calcCount(promotionInfo.getRid(), config.getTargetStruct());
                promotionInfo.getCountMap().put(config.getIdx(), count);
            });
            promotionInfo.setCurrDay(interDays);
            updatePromotion(promotionInfo);
        }
        return promotionInfo;
    }

    /**
     * 在本轮活动结束时执行
     *
     * @param control
     */
    public void handleOnPromotionClear(PromotionControl control) {
        List<Mail> mails = new ArrayList<>();
        List<Promotion030MysteryBox> promotions = getAllPromotionInfo();

        promotions.forEach(promotion030MysteryBox -> {
            List<CPromotion030MysteryBoxRechargeReward> rechargeConfigs = promotion030MysteryBoxRechargeRewardSysCache.
                    getConfigsByTurn(control.getTurns()).stream().filter(config -> config.getRecharge_need() <= promotion030MysteryBox.getRecharge()
                    && !promotion030MysteryBox.getRechargeRewardRecord().contains(config.getIdx())).collect(Collectors.toList());

            List<ImmutableThing> rechargeReward = new ArrayList<>();
            List<ImmutableThing> finalRechargeReward = rechargeReward;
            rechargeConfigs.forEach(config -> {
                finalRechargeReward.addAll(config.getReward());
                promotion030MysteryBox.getRechargeRewardRecord().add(config.idx);
            });
            rechargeReward = ImmutableThingUtil.mergeThing(rechargeReward);
            if (!rechargeReward.isEmpty()) {
                Mail mailRecharge = mailService.newMailNoTitle(promotion030MysteryBox.getRid(), MailScene.SHEN_MI_MO_HE_RECHARGE
                        , null, rechargeReward, GameEvent.MYSTERY_BOX);
                mails.add(mailRecharge);
            }

            List<CPromotion030MysteryBoxLevelReward> levelConfigs = promotion030MysteryBoxLevelRewardSysCache.getConfigsByTurn(control.getTurns())
                    .stream().filter(config -> config.getExp_need() <= promotion030MysteryBox.getExp()
                            && !promotion030MysteryBox.getLevelRewardRecord().contains(config.getLevel())).collect(Collectors.toList());
            List<ImmutableThing> levelReward = new ArrayList<>();
            List<ImmutableThing> finalLevelReward = levelReward;
            levelConfigs.forEach(config -> {
                finalLevelReward.addAll(config.getReward());
                promotion030MysteryBox.getLevelRewardRecord().add(config.getLevel());
            });

            updatePromotion(promotion030MysteryBox);
            levelReward = ImmutableThingUtil.mergeThing(levelReward);
            if (!levelReward.isEmpty()) {
                Mail mail = mailService.newMailNoTitle(promotion030MysteryBox.getRid(), MailScene.SHEN_MI_MO_HE_LEVEL
                        , null, levelReward, GameEvent.MYSTERY_BOX);
                mails.add(mail);
            }
        });
        if (!mails.isEmpty())
            mailService.insertMails(mails);
    }

    /***
     * 获取本轮,本天所有配置
     * @return
     */
    public List<CPromotion030MysteryBox> getConfigByTurnsAndDay() {
        int now = DateTimeUtil.currentSecond();
        PromotionControl control = promotionControlService.getControl(thisPromotionType());
        return promotion030MysteryBoxSysCache.getConfigsByTurn(control.getTurns()).stream()
                .filter(config -> DateTimeUtil.apartDay(control.getStartTime(), now) + 1 == config.getDay()).collect(Collectors.toList());
    }

    /***
     * 获取本轮本天该类型的任务
     * @param type
     * @return
     */
    public List<CPromotion030MysteryBox> getConfigsByTypeAndDays(TargetType type) {
        if (promotionControlService.isPromotionRunning(thisPromotionType()))
            return getConfigByTurnsAndDay().stream().filter(config -> config.getTargetStruct().getType() == type).collect(Collectors.toList());
        return Collections.emptyList();
    }

    /***
     * 登录事件调用,这时候客户端没有数据,不用推送
     * @param rid
     * @param config
     * @param addValue
     */
    public boolean loginAdd(long rid, CPromotion030MysteryBox config, int addValue) {
        Promotion030MysteryBox promotionInfo = getPromotionInfo(rid);
        Map<Integer, Integer> countMap = promotionInfo.getCountMap();
        int currValue = countMap.getOrDefault(config.getIdx(), 0);

        countMap.put(config.getIdx(), currValue + addValue);
        updatePromotion(promotionInfo);
        return true;
    }

    public void addCount(long rid, CPromotion030MysteryBox config, int addValue) {
        if (!loginAdd(rid, config, addValue)) {
            return;
        }
        Promotion030MysteryBox promotionInfo = getPromotionInfo(rid);
        updateToClient(rid, config, promotionInfo);
    }

    public void updateToClient(long rid, CPromotion030MysteryBox config, Promotion030MysteryBox promotionInfo) {
        Task4GMsg.GResMysteryBoxGet.Builder builder = Task4GMsg.GResMysteryBoxGet.newBuilder();
        Task4GMsg.PSActivityUnit.Builder unitBuilder = Task4GMsg.PSActivityUnit.newBuilder();
        unitBuilder.setIdx(config.getIdx());

        unitBuilder.setIsGot(promotionInfo.getRewardRecord().contains(config.getIdx()) ? 1 : 0);
        int count = Math.min(promotionInfo.getCountMap().getOrDefault(config.getIdx(), 0), config.getTargetStruct().getTarget());
        unitBuilder.setProgress(count);
        builder.setUnit(unitBuilder);
        builder.setExp(promotionInfo.getExp());
        contextManager.write(rid, CmdCode._13138, builder.build());
    }

    public void setCount(long rid, CPromotion030MysteryBox config, int newValue) {

        Promotion030MysteryBox promotionInfo = getPromotionInfo(rid);
        Map<Integer, Integer> countMap = promotionInfo.getCountMap();

        countMap.put(config.getIdx(), newValue);
        updatePromotion(promotionInfo);

        updateToClient(rid, config, promotionInfo);
    }

}
