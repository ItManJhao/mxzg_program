package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeConstants;
import com.ayjs.mxzg.config.excel.cache.BuyGemSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion050FestivalOvervalueGiftDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion050FestivalOvervalueGift;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion050FestivalOvervalueGiftConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Service
@Observer
@Slf4j
public class Promotion050FestivalOvervalueGiftService extends BasePromotionService<Promotion050FestivalOvervalueGift> implements IRechargeBuyingService {

    @Autowired
    private Promotion050FestivalOvervalueGiftDao promotion050FestivalOvervalueGiftDao;
    @Autowired
    private BuyGemSysCache buyGemSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private MailService mailService;
    @Autowired
    private ServerParamService serverParamService;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.JIE_RI_LI_BAO;
    }

    @Override
    public IRepository<Promotion050FestivalOvervalueGift> getRepository() {
        return promotion050FestivalOvervalueGiftDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion050FestivalOvervalueGift promotion, PromotionControl control) {
        promotion.setReceiveDay(0);
        promotion.getBuyGift().clear();
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.FESTIVAL_OVERVALUE_GIFT;
    }

    /**
     * 跨天在线
     *
     * @param event
     */
    /*@Subscribe
    private void listen(ZeroTimeEvent event) {
        if (promotionControlService.isPromotionRecording(thisPromotionType())) {

            Promotion050FestivalOvervalueGift promotion = getRepository().get(event.getRid());
            if (DateTimeUtil.isSameDate(promotion.getTime(), DateTimeUtil.currentSecond())) {
                return;
            }

            promotion.setTime(DateTimeUtil.currentSecond());
            promotion.setDay(promotion.getDay() + 1);
            updatePromotion(promotion);

            Promotion050GMsg.GResFestivalReceiveDay.Builder builder = Promotion050GMsg.GResFestivalReceiveDay.newBuilder();
            builder.setDay(promotion.getDay());
            contextManager.write(event.getRid(), CmdCode._53003, builder.build());
        }
    }*/

    /**
     * 该礼包是否可以购买
     *
     * @param rid
     * @param productId
     * @return
     */
    @Override
    public boolean canBuy(long rid, int productId) {

        if (!promotionControlService.isPromotionRecording(thisPromotionType())) {
            return false;
        }

        CBuyGem buyGem = buyGemSysCache.getOrThrow(productId);
        if (buyGem == null) {
            return false;
        }
        Promotion050FestivalOvervalueGiftConfig config = selectConfigProductionId(productId);
        if (config == null) {
            return false;
        }

        Promotion050FestivalOvervalueGift promotion050FestivalOvervalueGift = getPromotionInfo(rid);
        if (!promotion050FestivalOvervalueGift.getBuyGift().contains(config.getIdx())) {
            return true;
        }
        return false;
    }


    /**
     * 记录限购次数
     *
     * @param rid
     * @param cBuyGem
     */
    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {

        Promotion050FestivalOvervalueGiftConfig config = selectConfigProductionId(cBuyGem.getIdx());
        if (config == null) {
            return;
        }

        Promotion050FestivalOvervalueGift promotion050FestivalOvervalueGift = getPromotionInfo(rid);
        promotion050FestivalOvervalueGift.getBuyGift().add(config.getIdx());
        updatePromotion(promotion050FestivalOvervalueGift);

        if (isGm) {
            if (config.getGrid_type() != 1) {
                thingService.add(rid, ImmutableThingUtil.fromJson(config.getGift_reward()), GameEvent.GM_RECHARGE);
            }
        } else {
            if (config.getGrid_type() != 1) {
                thingService.add(rid, ImmutableThingUtil.fromJson(config.getGift_reward()), GameEvent.FESTIVAL_OVERVALUE_GIFT);
            }
        }

    }

    private Collection<Promotion050FestivalOvervalueGiftConfig> selectConfigAll() {
        return promotionControlService.getControl(thisPromotionType()).getAllConfig(Promotion050FestivalOvervalueGiftConfig.class);
    }

    /**
     * 根据配置表idx获取配置
     *
     * @param idx
     * @return
     */
    public Promotion050FestivalOvervalueGiftConfig selectConfigIdx(int idx) {
        return promotionControlService.getControl(thisPromotionType()).getConfig(idx, Promotion050FestivalOvervalueGiftConfig.class);
    }

    /**
     * 根据商品id获取配置
     *
     * @param productionId
     * @return
     */
    private Promotion050FestivalOvervalueGiftConfig selectConfigProductionId(int productionId) {
        Promotion050FestivalOvervalueGiftConfig model = null;
        for (Promotion050FestivalOvervalueGiftConfig config : selectConfigAll()) {
            if (config.getProduction_id() == productionId) {
                model = config;
            }
        }
        return model;
    }

    /**
     * 获取活动已进行的天数
     */
    public int getPromotionRunDay(int nowTime) {
        PromotionControl promotionControl = promotionControlService.getControl(PromotionType.JIE_RI_LI_BAO);

        //获取活动开始时间
        int openBreak = DateTimeUtil.theDayBreak(serverParamService.getServerStartTime());
        int startTime = Math.max(openBreak + TimeConstants.ONE_DAY_SECOND * (promotionControl.getLimitDays() - 1), promotionControl.getStartTime());

        return DateTimeUtil.apartDay(startTime, nowTime) + 1;
    }

    /**
     * 处理邮件补发
     *
     * @param control
     */
    @Override
    public void handleOnPromotionClear(PromotionControl control) {
        List<Mail> mailList = new ArrayList<>();

        getAllPromotionInfo().forEach(promotion -> {
            promotion.getBuyGift().forEach(idx -> {
                Promotion050FestivalOvervalueGiftConfig config = selectConfigIdx(idx);

                if (config.getGrid_type() == 1 && getPromotionRunDay(control.getEndTime()) > promotion.getReceiveDay()) {//礼包类型为超值礼包

                    Mail mail = mailService.newMailNoTitle(promotion.getRid(), MailScene.JIE_RI_HAO_LU, null,
                            ImmutableThingUtil.multiplyThing(ImmutableThingUtil.fromJson(config.getGift_reward()),
                                    getPromotionRunDay(control.getEndTime()) - promotion.getReceiveDay()), GameEvent.FESTIVAL_OVERVALUE_GIFT);

                    mailList.add(mail);

                }
            });
        });
        if (mailList.size() > 0)
            mailService.insertMails(mailList);
    }
}
