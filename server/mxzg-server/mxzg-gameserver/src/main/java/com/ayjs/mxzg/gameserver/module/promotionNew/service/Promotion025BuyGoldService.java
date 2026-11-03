/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion025BuyGoldRankSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion025BuyGoldRank;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.buygold.event.BuyGoldEvent;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.mail.struct.MailParams;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion025BuyGoldDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion025BuyGold;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.BuyGoldRankEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.rank.BuyGoldRankService;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractRankService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author YY
 *
 */
@Observer
@Service
public class Promotion025BuyGoldService extends BaseRankablePromotionService<Promotion025BuyGold> {

    @Autowired
    private Promotion025BuyGoldDao promotion025BuyGoldDao;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private BuyGoldRankService buyGoldRankService;
    @Autowired
    private Promotion025BuyGoldRankSysCache promotion025BuyGoldRankSysCache;
    @Autowired
    private MailService mailService;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.DIAN_SHI_CHENG_JIN;
    }

    @Override
    public IRepository<Promotion025BuyGold> getRepository() {
        return promotion025BuyGoldDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion025BuyGold promotion, PromotionControl control) {
        promotion.setRankCount(0);
        promotion.getTakeRewards().clear();
    }

    /**
     * 记录点金次数
     * @param rid
     * @param productionId
     */
    @Subscribe
    public void addBuyGoldcount(BuyGoldEvent event) {
        if (!promotionControlService.canRecordPromotionData(event.getRid(), thisPromotionType())) {
            return;
        }
        Promotion025BuyGold promotion = this.getPromotionInfo(event.getRid());
        promotion.setRankCount(promotion.getRankCount() + 1);
        updatePromotion(promotion);

        eventBus.post(BuyGoldRankEvent.of(event.getRid(), promotion.getRankCount()));
    }

    @Override
    protected AbstractRankService thisRankService() {
        return buyGoldRankService;
    }

    @Override
    protected Mail createPromotionRankMail(Promotion025BuyGold promotionInfo, int rank) {
        CPromotion025BuyGoldRank cConfig = promotion025BuyGoldRankSysCache.getByTurnsRank(promotionInfo.getTurns(), rank);
        if (cConfig == null) {
            return null;
        }
        Mail mail = mailService.newMailNoTitle(promotionInfo.getRid(), MailScene.DIAN_SHI_CHENG_JIN_RANK,
                MailParams.build(rank), cConfig.getReward(), GameEvent.DIAN_SHI_CHENG_JIN_RANK);
        return mail;
    }

    public List<Promotion025BuyGold> getAll() {
        return getAllPromotionInfo();
    }
}
