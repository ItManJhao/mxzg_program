/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeConstants;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.BuyGemSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion006InvestSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion006Invest;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.monthCard.constant.MonthCardType;
import com.ayjs.mxzg.gameserver.module.monthCard.domain.MonthCard;
import com.ayjs.mxzg.gameserver.module.monthCard.serice.MonthCardService;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion006InvestDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion006Invest;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MonthCardInvest;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;

/**
 * @author YY
 *
 */
@Observer
@Service
public class Promotion006InvestService implements IRechargeBuyingService {

    @Autowired
    private Promotion006InvestDao promotion006InvestDao;
    @Autowired
    private Promotion006InvestSysCache promotion006InvestSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private BuyGemSysCache buyGemSysCache;
    @Autowired
    private MonthCardService monthCardService;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private MailService mailService;

    public Promotion006Invest getInvest(long rid) {
        Promotion006Invest invest = promotion006InvestDao.get(rid);
        if (invest == null) {
            invest = new Promotion006Invest();
            invest.setRid(rid);
            invest.setShowType(0);
            invest.setInvest(new HashMap<>());
            invest.setStartTime(DateTimeUtil.currentSecond());
            invest.setEndTime(DateTimeUtil.currentSecond() + systemSysCache.getPromotionInvestShowTime());
            promotion006InvestDao.add(invest);
        } else {
            if (DateTimeUtil.currentSecond() >= invest.getEndTime()) {
                //重置数据
                invest.setShowType(0);
                //当玩家长时间未登陆时。重置该玩家的图标显示时间
                if (DateTimeUtil.currentSecond() >= invest.getEndTime() + systemSysCache.getPromotionInvestDisappearTime()) {
                    invest.setStartTime(DateTimeUtil.dayBreak());
                } else {
                    invest.setStartTime(DateTimeUtil.theDayBreak(invest.getEndTime()) + systemSysCache.getPromotionInvestDisappearTime());
                }
                invest.setEndTime(invest.getStartTime() + systemSysCache.getPromotionInvestShowTime());
                //执行邮件补发
                this.promotionMail(invest);
                //清除基金购买记录
                invest.getInvest().clear();
                this.updateInvest(invest);
            }
            //此段代码用于修复月基金结束而购买纪录没清除的问题。后续可以删除。
            if (invest.getShowType() == 0 && invest.getInvest().size() > 0) {
                invest.getInvest().clear();
                this.updateInvest(invest);
            }
        }
        return invest;
    }

    public void updateInvest(Promotion006Invest invest) {
        promotion006InvestDao.update(invest);
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.MONTH_CARD;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        MonthCard monthCard = monthCardService.getByType(rid, MonthCardType.BEST);
        if (monthCard == null) {
            return false;
        }
        if (TimeDateUtil.getCurrentTimeInt() > monthCard.getEndTime()) {
            return false;
        }
        CBuyGem cBuyGem = buyGemSysCache.getOrThrow(productId);
        if (cBuyGem == null) {
            return false;
        }
        Promotion006Invest invest = getInvest(rid);
        if (invest.getStartTime() > DateTimeUtil.currentSecond() || DateTimeUtil.currentSecond() > invest.getEndTime()) {
            return false;
        }

        CPromotion006Invest cType = promotion006InvestSysCache.getDay0(cBuyGem.getIdx());
        MonthCardInvest monthInvest = invest.getInvest().get(cType.getProduction_id());
        if (monthInvest == null) {
            return true;
        }/*
        if (monthInvest.getReceiveDay() >= promotion006InvestSysCache.getMaxDay()) {
            return true;
        }*/
        return false;
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {

        Promotion006Invest invest = getInvest(rid);
        CPromotion006Invest day0Type = promotion006InvestSysCache.getDay0(cBuyGem.getIdx());

        List<ImmutableThing> rewardList = new ArrayList<>();

        MonthCardInvest monthCard = invest.getInvest().get(day0Type.getProduction_id());
        if (monthCard != null) {
            int zeroTime = TimeDateUtil.getSomedayZeroInt(monthCard.getBuyTime());
            int nowTime = TimeDateUtil.getCurrentTimeInt();
            //可以领取到的天数
            int reachDay = (nowTime - zeroTime) / TimeDateUtil.ONEDAYINT + 1;
            //如果玩家确实在月卡还没有结束之前又成功支付了月卡的费用，就把未领取的月卡奖励给到
            List<ImmutableThing> list = promotion006InvestSysCache.getByTypeDay(day0Type.getProduction_id(), monthCard.getReceiveDay(), reachDay);
            if (list != null) {
                rewardList.addAll(list);
            }
        } else {
            monthCard = new MonthCardInvest();
            monthCard.setType(day0Type.getProduction_id());
            invest.getInvest().put(monthCard.getType(), monthCard);
        }
        rewardList.addAll(day0Type.getReward());

        monthCard.setBuyTime(DateTimeUtil.currentSecond());
        monthCard.setReceiveDay(0);
        invest.setShowType(1);//购买月卡更改前端显示模式
        invest.setStartTime(DateTimeUtil.currentSecond());
        invest.setEndTime(DateTimeUtil.theDayBreak(invest.getStartTime() + promotion006InvestSysCache.getMaxDay() * TimeConstants.ONE_DAY_SECOND));
        promotion006InvestDao.update(invest);

        if (isGm) {
            thingService.add(rid, rewardList, GameEvent.GM_RECHARGE);
        } else {
            thingService.add(rid, rewardList, GameEvent.BUY_INVEST_GAIN);
        }

    }

    private static final int INVEST128 = 21;
    private static final int INVEST328 = 22;

  /*  @Subscribe
    private void listen(LoginEvent event) {
        Promotion006Invest invest = this.getInvest(event.getRid());
        int nowTime = TimeDateUtil.getCurrentTimeInt();
        boolean needUpdate = false;
        *//*for (MonthCardInvest cardInvest : invest.getInvest().values()) {
            if (cardInvest.getBuyTime() <= 0) {
                continue;
            }
            int zeroTime = TimeDateUtil.getSomedayZeroInt(cardInvest.getBuyTime());
            int reachDay = (nowTime - zeroTime) / TimeDateUtil.ONEDAYINT + 1;

            if (reachDay <= promotion006InvestSysCache.getMaxDay()) {
                continue;
            }
            List<ImmutableThing> list = promotion006InvestSysCache.getByTypeDay(cardInvest.getType(), cardInvest.getReceiveDay(), reachDay);
            if (list == null || list.isEmpty()) {
                continue;
            }
            cardInvest.setReceiveDay(reachDay);
            needUpdate = true;
            if (cardInvest.getType() == INVEST128) {
                Mail mail = mailService.newSimpleMail(event.getRid(), MailScene.INVEST_128_GAIN, list, GameEvent.INVEST_SYS_GAIN);
                mailService.insert(mail);
            } else if (cardInvest.getType() == INVEST328) {
                Mail mail = mailService.newSimpleMail(event.getRid(), MailScene.INVEST_328_GAIN, list, GameEvent.INVEST_SYS_GAIN);
                mailService.insert(mail);
            }
        }
        if (needUpdate) {
            updateInvest(invest);
        }*//*
    }
*/

    /**
     * 执行邮件补发
     * @param invest
     */
    private void promotionMail(Promotion006Invest invest) {
        int nowTime = DateTimeUtil.currentSecond();
        for (MonthCardInvest cardInvest : invest.getInvest().values()) {
            if (cardInvest.getBuyTime() <= 0) {
                continue;
            }
            int zeroTime = TimeDateUtil.getSomedayZeroInt(cardInvest.getBuyTime());
            int reachDay = (nowTime - zeroTime) / TimeDateUtil.ONEDAYINT + 1;

            if (reachDay <= promotion006InvestSysCache.getMaxDay()) {
                continue;
            }
            List<ImmutableThing> list = promotion006InvestSysCache.getByTypeDay(cardInvest.getType(), cardInvest.getReceiveDay(), reachDay);
            if (list == null || list.isEmpty()) {
                continue;
            }
            list = ImmutableThingUtil.mergeThing(list);
            if (cardInvest.getType() == INVEST128) {
                Mail mail = mailService.newSimpleMail(invest.getRid(), MailScene.INVEST_128_GAIN, list, GameEvent.INVEST_SYS_GAIN);
                mailService.insert(mail);
            } else if (cardInvest.getType() == INVEST328) {
                Mail mail = mailService.newSimpleMail(invest.getRid(), MailScene.INVEST_328_GAIN, list, GameEvent.INVEST_SYS_GAIN);
                mailService.insert(mail);
            }
        }
    }
}
