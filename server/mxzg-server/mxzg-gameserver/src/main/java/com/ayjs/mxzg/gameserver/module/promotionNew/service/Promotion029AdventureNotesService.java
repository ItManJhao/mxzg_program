package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion029AdventureNotesLevelRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion029AdventureNotesRechargeRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion029AdventureNotesSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion029AdventureNotes;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion029AdventureNotesLevelReward;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion029AdventureNotesRechargeReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion029AdventureNotesDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion029AdventureNotes;
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
public class Promotion029AdventureNotesService extends BasePromotionService<Promotion029AdventureNotes> {

    @Autowired
    private Promotion029AdventureNotesDao promotion029AdventureNotesDao;
    @Autowired
    private Promotion029AdventureNotesSysCache promotion029AdventureNotesSysCache;
    @Autowired
    private Promotion029AdventureNotesRechargeRewardSysCache promotion029AdventureNotesRechargeRewardSysCache;
    @Autowired
    private Promotion029AdventureNotesLevelRewardSysCache promotion029AdventureNotesLevelRewardSysCache;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private TargetCounterService targetCounterService;
    @Autowired
    private MailService mailService;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.MAO_XIAN_RI_JI;
    }

    @Override
    public IRepository<Promotion029AdventureNotes> getRepository() {
        return promotion029AdventureNotesDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion029AdventureNotes promotion, PromotionControl control) {
        promotion.setRecharge(0);
        promotion.getRechargeRewardRecord().clear();
        promotion.getCountMap().clear();
        promotion.setExp(0);
        promotion.getRewardRecord().clear();
        promotion.getLevelRewardRecord().clear();
        promotion.setLastLoginTime(0);
    }

    @Override
    public void handleOnPromotionNewTurns(PromotionControl control) {
        int now = DateTimeUtil.currentSecond();

        List<Promotion029AdventureNotes> list = getAllPromotionInfo();
        for (Promotion029AdventureNotes promotionInfo : list) {
            promotionInfo.setRecharge(0);
            promotionInfo.setExp(0);
        }
        promotion029AdventureNotesDao.update(list);

        contextManager.getAllOnline().stream().filter(playerContext -> playerContext.getId() > 0).forEach(playerContext -> {
            List<CPromotion029AdventureNotes> configs = getConfigsByTypeAndDay(TargetType.LOGIN);
            Promotion029AdventureNotes promotionInfo = getPromotionInfo(playerContext.getId());
            if (!TimeDateUtil.isToday(promotionInfo.getLastLoginTime())) {
                promotionInfo.setLastLoginTime(now);
                updatePromotion(promotionInfo);
                configs.forEach(config -> {
                    addCount(playerContext.getId(), config, 1);
                });
            }
        });
    }

    /**
     * 在本轮活动结束时执行
     *
     * @param control
     */
    public void handleOnPromotionClear(PromotionControl control) {
        List<Promotion029AdventureNotes> promotions = getAllPromotionInfo();

        List<Mail> newMails = new ArrayList<>();
        promotions.forEach(promotion029AdventureNotes -> {
            List<CPromotion029AdventureNotesRechargeReward> rechargeConfigs = promotion029AdventureNotesRechargeRewardSysCache.
                    getConfigsByTurn(control.getTurns()).stream().filter(config -> config.getRecharge_need() <= promotion029AdventureNotes.getRecharge()
                    && !promotion029AdventureNotes.getRechargeRewardRecord().contains(config.getIdx())).collect(Collectors.toList());

            List<ImmutableThing> rechargeReward = new ArrayList<>();
            rechargeConfigs.forEach(config -> {
                rechargeReward.addAll(config.getReward());
                promotion029AdventureNotes.getRechargeRewardRecord().add(config.getIdx());
            });
            if (!rechargeReward.isEmpty()) {
                Mail mailRecharge = mailService.newMailNoTitle(promotion029AdventureNotes.getRid(), MailScene.MAO_XIAN_RI_JI_RECHARGE
                        , null, rechargeReward, GameEvent.ADVENTURE_NOTES);
                newMails.add(mailRecharge);
            }

            List<CPromotion029AdventureNotesLevelReward> levelConfigs = promotion029AdventureNotesLevelRewardSysCache.
                    getConfigsByTurn(control.getTurns()).stream().filter(config -> config.getExp_need() <= promotion029AdventureNotes.getExp()
                    && !promotion029AdventureNotes.getLevelRewardRecord().contains(config.getLevel())).collect(Collectors.toList());
            List<ImmutableThing> levelReward = new ArrayList<>();
            levelConfigs.forEach(config -> {
                levelReward.addAll(config.getReward());
                promotion029AdventureNotes.getLevelRewardRecord().add(config.getLevel());
            });

            updatePromotion(promotion029AdventureNotes);

            if (!levelReward.isEmpty()) {
                Mail mail = mailService.newMailNoTitle(promotion029AdventureNotes.getRid(), MailScene.MAO_XIAN_RI_JI_LEVEL
                        , null, levelReward, GameEvent.ADVENTURE_NOTES);
                newMails.add(mail);
            }
        });
        if (!newMails.isEmpty())
            mailService.insertMails(newMails);
    }

    @Override
    public Promotion029AdventureNotes getPromotionInfo(long rid) {
        Promotion029AdventureNotes promotionInfo = super.getPromotionInfo(rid);
        if (!promotionControlService.isPromotionRunning(thisPromotionType())) {
            return promotionInfo;
        }
        PromotionControl control = promotionControlService.getControl(thisPromotionType());
        int now = DateTimeUtil.currentSecond();
        int interDays = DateTimeUtil.apartDay(control.getStartTime(), now) + 1;
        if (interDays != promotionInfo.getCurrDay()) {
            promotionInfo.getCountMap().clear();
            getConfigByTurns().forEach(config -> {
                //初始化所有值
                int count = targetCounterService.calcCount(promotionInfo.getRid(), config.getTargetStruct());
                promotionInfo.getCountMap().put(config.getIdx(), count);
            });
            promotionInfo.setCurrDay(interDays);
            updatePromotion(promotionInfo);
        }
        return promotionInfo;
    }


    /***
     * 获取本轮,本天所有配置
     * @return
     */
    public List<CPromotion029AdventureNotes> getConfigByTurns() {
        PromotionControl control = promotionControlService.getControl(thisPromotionType());
        int now = DateTimeUtil.currentSecond();
        return promotion029AdventureNotesSysCache.getConfigsByTurn(control.getTurns()).stream()
                .filter(config -> DateTimeUtil.apartDay(control.getStartTime(), now) + 1 == config.getDay()).collect(Collectors.toList());
    }

    /***
     * 获取本轮该类型的任务
     * @param type
     * @return
     */
    public List<CPromotion029AdventureNotes> getConfigsByTypeAndDay(TargetType type) {
        if (promotionControlService.isPromotionRunning(thisPromotionType()))
            return getConfigByTurns().stream().filter(config -> config.getTargetStruct().getType() == type).collect(Collectors.toList());
        return Collections.emptyList();
    }

    /***
     * 登录事件调用,这时候客户端没有数据,不用推送
     * @param rid
     * @param config
     * @param addValue
     */
    public void loginAdd(long rid, CPromotion029AdventureNotes config, int addValue) {
        if (!promotionControlService.isPromotionRunning(thisPromotionType())) {
            return;
        }
        Promotion029AdventureNotes promotionInfo = getPromotionInfo(rid);
        Map<Integer, Integer> countMap = promotionInfo.getCountMap();
        int currValue = countMap.getOrDefault(config.getIdx(), 0);
        if (currValue >= config.getTargetStruct().getTarget()) {
            //目标完成后，不改变值
            return;
        }
        countMap.put(config.getIdx(), Math.min(currValue + addValue, config.getTargetStruct().getTarget()));
        updatePromotion(promotionInfo);
    }

    public void addCount(long rid, CPromotion029AdventureNotes config, int addValue) {
        if (!promotionControlService.isPromotionRunning(thisPromotionType())) {
            return;
        }
        Promotion029AdventureNotes promotionInfo = getPromotionInfo(rid);
        Map<Integer, Integer> countMap = promotionInfo.getCountMap();
        int currValue = countMap.getOrDefault(config.getIdx(), 0);

        countMap.put(config.getIdx(), currValue + addValue);
        updatePromotion(promotionInfo);
        //跟新进度
        updateToClient(rid, config, promotionInfo);

//        builder
    }

    public void updateToClient(long rid, CPromotion029AdventureNotes config, Promotion029AdventureNotes promotionInfo) {
        Task4GMsg.GResAdventureNoteGet.Builder builder = Task4GMsg.GResAdventureNoteGet.newBuilder();
        Task4GMsg.PSActivityUnit.Builder unitBuilder = Task4GMsg.PSActivityUnit.newBuilder();
        unitBuilder.setIdx(config.getIdx());

        unitBuilder.setIsGot(promotionInfo.getRewardRecord().contains(config.getIdx()) ? 1 : 0);
        int count = promotionInfo.getCountMap().getOrDefault(config.getIdx(), 0);
        unitBuilder.setProgress(count);
        builder.setUnit(unitBuilder);
        builder.setExp(promotionInfo.getExp());
        contextManager.write(rid, CmdCode._13133, builder.build());
    }

    public void setCount(long rid, CPromotion029AdventureNotes config, int newValue) {

        Promotion029AdventureNotes promotionInfo = getPromotionInfo(rid);
        Map<Integer, Integer> countMap = promotionInfo.getCountMap();

        countMap.put(config.getIdx(), newValue);
        updatePromotion(promotionInfo);

        updateToClient(rid, config, promotionInfo);
    }

}
