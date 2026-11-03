/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion028TavernWeeklyRankSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion028TavernWeeklyRank;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.struct.MailParams;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion028TavernInfoDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion028TavernInfo;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.TavernRankEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.rank.TavernRankService;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractRankService;
import com.ayjs.mxzg.gameserver.module.task.event.TavernTaskRewardEvent;

/**
 * @author YY
 *
 */
@Observer
@Service
public class Promotion028TavernInfoService extends BaseRankablePromotionService<Promotion028TavernInfo> {

    @Autowired
    private Promotion028TavernInfoDao promotion028TavernInfoDao;
    @Autowired
    private Promotion028TavernWeeklyRankSysCache promotion028TavernWeeklyRankSysCache;
    @Autowired
    private TavernRankService tavernRankService;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.JIU_GUAN_CHANG_KE;
    }

    @Override
    public IRepository<Promotion028TavernInfo> getRepository() {
        return promotion028TavernInfoDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion028TavernInfo promotion, PromotionControl control) {
        promotion.setRankCount(0);
        promotion.getTakeRewards().clear();
    }

    @Override
    protected AbstractRankService thisRankService() {
        return tavernRankService;
    }

    @Override
    protected Mail createPromotionRankMail(Promotion028TavernInfo promotionInfo, int rank) {
        CPromotion028TavernWeeklyRank cConfig = promotion028TavernWeeklyRankSysCache.getByTurnsRank(promotionInfo.getTurns(), rank);
        if (cConfig == null) {
            return null;
        }
        Mail mail = mailService.newMailNoTitle(promotionInfo.getRid(), MailScene.JIU_GUAN_CHANG_KE_RANK,
                MailParams.build(rank), cConfig.getReward(), GameEvent.JIU_GUAN_CHANG_KE_RANK);
        return mail;
    }

    @Subscribe
    private void listen(TavernTaskRewardEvent event) {
        if (!promotionControlService.canRecordPromotionData(event.getRid(), thisPromotionType())) {
            return;
        }
        Promotion028TavernInfo promotion = this.getPromotionInfo(event.getRid());
        promotion.setRankCount(promotion.getRankCount() + event.getTaskIds().size());
        updatePromotion(promotion);

        eventBus.post(TavernRankEvent.of(event.getRid(), promotion.getRankCount()));
    }
}
