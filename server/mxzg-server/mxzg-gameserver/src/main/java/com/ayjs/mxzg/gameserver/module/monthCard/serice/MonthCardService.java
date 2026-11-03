package com.ayjs.mxzg.gameserver.module.monthCard.serice;

import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion008CardSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion008Card;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.monthCard.constant.MonthCardType;
import com.ayjs.mxzg.gameserver.module.monthCard.dao.MonthCardDao;
import com.ayjs.mxzg.gameserver.module.monthCard.domain.MonthCard;
import com.ayjs.mxzg.gameserver.module.recharge.service.RoleRechargeService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.protocol.Task1GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.ImmutableList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2019/10/16
 **/
@Service
public class MonthCardService {

    @Autowired
    MonthCardDao monthCardDao;
    @Autowired
    private Promotion008CardSysCache promotion008CardSysCache;
    @Autowired
    RoleRechargeService roleRechargeService;
    @Autowired
    ContextManager contextManager;
    @Autowired
    RoleService roleService;
    @Autowired
    ThingService thingService;
    @Autowired
    ServerParamService serverParamService;
    @Autowired
    MailService mailService;

    public ErrorCode reward(long rid, int idx) {
        CPromotion008Card config = promotion008CardSysCache.getOrThrow(idx);
        if (config == null) {
            return ErrorCode.CONFIG_NOT_EXISTS;
        }
        Role role = roleService.getOrThrow(rid);
        if (role == null)
            return ErrorCode.ROLE_NOT_EXIST;
        MonthCard monthCard = load(rid, idx);
        if (monthCard == null || monthCard.getEndTime() < TimeDateUtil.getCurrentTimeInt()) {
            return ErrorCode.MONTH_CAR_EXPIRE;
        }

        int now = TimeDateUtil.getCurrentTimeInt();
        if (DateTimeUtil.isSameDate(monthCard.getRewardTime(), now)) {
            return ErrorCode.PROMOTION_ID_HAD_REWARD;
        }
        int interval = TimeDateUtil.intervalDays(monthCard.getStartTime(), now);
        int rewardDay = interval - monthCard.getRewardCount();
        monthCard.setRewardCount(monthCard.getRewardCount() + 1);
        monthCard.setRewardTime(now);
        monthCard.setRewardCount(interval);
        monthCardDao.update(monthCard);
        ImmutableList<ImmutableThing> rewards = config.getItem();
        List<ImmutableThing> rewardList = ImmutableThingUtil.multiplyThing(rewards, rewardDay);
        thingService.add(role.getId(), rewardList, GameEvent.MONTH_VIP_REWARD);

        Task1GMsg.GResMonthCardReward.Builder builder = Task1GMsg.GResMonthCardReward.newBuilder();
        builder.setIdx(idx);
        builder.setIsGain(1);
        contextManager.write(rid, CmdCode._13025, builder.build());
        return ErrorCode.NO_ERROR;
    }


    public MonthCard load(long rid, int idx) {
        List<MonthCard> monthCards = getAll(rid);
        MonthCard monthCard = monthCards.stream().filter(monthCard1 -> monthCard1.getIdx() == idx).findFirst().orElse(null);
        if (monthCard == null) {
            monthCard = new MonthCard();
            monthCard.setIdx(idx);
            monthCard.setRid(rid);
            CPromotion008Card cPromotionCard = promotion008CardSysCache.getOrThrow(idx);
            monthCard.setType(cPromotionCard.getType());
            monthCardDao.add(monthCard);
        }
        return monthCard;
    }

    /**
     * 根据类型获取月卡
     *
     * @param rid
     * @param type
     * @return 当没有激活该类型的月卡时，返回空
     */
    public MonthCard getByType(long rid, MonthCardType type) {
        List<MonthCard> monthCards = getAll(rid);
        MonthCard monthCard = monthCards.stream().filter(monthCard1 -> monthCard1.getType() == type.getType()).findFirst().orElse(null);
        return monthCard;
    }

    public List<MonthCard> getAll(long rid) {
        List<MonthCard> monthCards = monthCardDao.getAllById(rid);
        monthCards.forEach(monthCard -> {
            //过期后重置金额
            CPromotion008Card config = promotion008CardSysCache.getOrThrow(monthCard.getIdx());
            int now = DateTimeUtil.currentSecond();
            if (monthCard.getStartTime() != 0 && monthCard.getEndTime() < now) {
                int count = config.getDay() - monthCard.getRewardCount();
                monthCard.setRewardCount(0);
                monthCard.setRechargeCount(0);
                monthCard.setStartTime(0);
                monthCard.setRewardTime(0);
                monthCardDao.update(monthCard);
                //邮件领奖
                if (count > 0) {
                    if (monthCard.getType() == MonthCardType.NORMAL.getType()) {
                        Mail mail = mailService.newMailNoTitle(monthCard.getRid(), MailScene.MONTH_CARD,
                                null, ImmutableThingUtil.multiplyThing(config.getItem(), count), GameEvent.MONTH_CARD);
                        mailService.insert(mail);
                    } else {
                        Mail mail = mailService.newMailNoTitle(monthCard.getRid(), MailScene.BEST_MONTH_CARD,
                                null, ImmutableThingUtil.multiplyThing(config.getItem(), count), GameEvent.MONTH_CARD);
                        mailService.insert(mail);
                    }
                }
            }
        });
        return monthCards;
    }

    public void update(MonthCard entity) {
        monthCardDao.update(entity);
    }

    public void add(MonthCard monthCard) {
        monthCardDao.add(monthCard);
    }

}
