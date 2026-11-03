/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.AdventurerewardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion027AdventureRankSysCache;
import com.ayjs.mxzg.config.excel.entity.CAdventurereward;
import com.ayjs.mxzg.config.excel.entity.CPromotionControl;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion027AdventureRank;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.adven.event.AdvenPassEvent;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.struct.MailParams;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion027AdventureDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion027Adventure;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.AdventureRankEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.rank.AdventureRankService;
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
public class Promotion027AdventureService extends BaseRankablePromotionService<Promotion027Adventure> {

    @Autowired
    private Promotion027AdventureDao promotion027AdventureDao;
    @Autowired
    private AdventureRankService adventureRankService;
    @Autowired
    private Promotion027AdventureRankSysCache promotion027AdventureRankSysCache;
    @Autowired
    private AdventurerewardSysCache adventurerewardSysCache;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.SHI_LIAN_ZHI_LU;
    }

    @Override
    public IRepository<Promotion027Adventure> getRepository() {
        return promotion027AdventureDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion027Adventure promotion, PromotionControl control) {
        promotion.setRankCount(0);
        promotion.getTakeRewards().clear();
    }

    /**
     * 记录次数
     */
    @Subscribe
    public void addAdventureCount(AdvenPassEvent event) {
        if (!event.isWin()) {
            return;
        }
        if (!promotionControlService.canRecordPromotionData(event.getRid(), thisPromotionType())) {
            return;
        }
        PromotionControl control = promotionControlService.getControl(thisPromotionType());
        
        CAdventurereward cAdventurereward = adventurerewardSysCache.getOrThrow(event.getIdx());
        if (cAdventurereward.getType() == 2) {
            return;
        }
        //FIXME 试炼之路的bug？
        int secondTime = TimeDateUtil.getCurrentTimeInt() - control.getStartTime();
        int runDay = secondTime / TimeDateUtil.ONEDAYINT;
        if(secondTime % TimeDateUtil.ONEDAYINT != 0) {
        	runDay++;
        }
        int maxCount = runDay * 15;
        Promotion027Adventure promotion = this.getPromotionInfo(event.getRid());
        if(promotion.getRankCount() >= maxCount) {
        	return;
        }
        promotion.setRankCount(promotion.getRankCount() + 1);
        updatePromotion(promotion);

        eventBus.post(AdventureRankEvent.of(event.getRid(), promotion.getRankCount()));
    }

    @Override
    protected AbstractRankService thisRankService() {
        return adventureRankService;
    }

    @Override
    protected Mail createPromotionRankMail(Promotion027Adventure promotionInfo, int rank) {
        CPromotion027AdventureRank cConfig = promotion027AdventureRankSysCache.getByTurnsRank(promotionInfo.getTurns(), rank);
        if (cConfig == null) {
            return null;
        }

        Mail mail = mailService.newMailNoTitle(promotionInfo.getRid(), MailScene.SHI_LIAN_ZHI_LU_RANK,
                MailParams.build(rank), cConfig.getReward(), GameEvent.SHI_LIAN_ZHI_LU_RANK);
        return mail;
    }

    public List<Promotion027Adventure> getAll() {
        return getAllPromotionInfo();
    }
}
