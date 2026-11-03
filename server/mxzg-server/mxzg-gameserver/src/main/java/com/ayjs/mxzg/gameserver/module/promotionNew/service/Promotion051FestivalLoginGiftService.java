package com.ayjs.mxzg.gameserver.module.promotionNew.service;


import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion051FestivalLoginGiftDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion051FestivalLoginGift;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.event.ZeroTimeEvent;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion037WishTimesConfig;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion051FestivalLoginGiftConfig;
import com.ayjs.mxzg.protocol.Promotion051GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.xml.crypto.Data;

/**
 *
 */
@Service
@Observer
public class Promotion051FestivalLoginGiftService extends BasePromotionService<Promotion051FestivalLoginGift> {

    @Autowired
    private Promotion051FestivalLoginGiftDao promotion051FestivalLoginGiftDao;
    @Autowired
    private ContextManager contextManager;


    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.JIE_RI_DENG_LU;
    }

    @Override
    public IRepository<Promotion051FestivalLoginGift> getRepository() {
        return promotion051FestivalLoginGiftDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion051FestivalLoginGift promotion, PromotionControl control) {
        promotion.setDay(0);
        promotion.setTime(0);
        promotion.getRewardList().clear();
    }

    /**
     * 跨天在线
     *
     * @param event
     */
    @Subscribe
    private void listen(ZeroTimeEvent event) {
        if (promotionControlService.isPromotionRecording(thisPromotionType())) {

            Promotion051FestivalLoginGift promotion = getPromotionInfo(event.getRid());
            if (DateTimeUtil.isSameDate(promotion.getTime(), DateTimeUtil.currentSecond())) {
                return ;
            }

            promotion.setTime(DateTimeUtil.currentSecond());
            promotion.setDay(promotion.getDay() + 1);
            updatePromotion(promotion);

            Promotion051GMsg.GResFestivalLoginUpdate.Builder builder = Promotion051GMsg.GResFestivalLoginUpdate.newBuilder();
            builder.setDay(promotion.getDay());
            contextManager.write(event.getRid(), CmdCode._52003,builder.build());
        }
    }

    public Promotion051FestivalLoginGiftConfig selectConfig(int idx){
        return promotionControlService.getControl(thisPromotionType()).getConfig(idx, Promotion051FestivalLoginGiftConfig.class);
    }

}
