/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion026SpeedfightRankSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion026SpeedFightRank;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.struct.MailParams;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion026SpeedFightDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion026SpeedFight;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.SpeedFightEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.SpeedFightRankEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.rank.SpeedFightRankService;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractRankService;

/**
 * @author YY
 *
 */
@Observer
@Service
public class Promotion026SpeedFightService extends BaseRankablePromotionService<Promotion026SpeedFight> {

	@Autowired
	private Promotion026SpeedFightDao promotion026SpeedFightDao;
	@Autowired
	private SpeedFightRankService speedFightRankService;
	@Autowired
	private Promotion026SpeedfightRankSysCache promotion026SpeedfightRankSysCache;
	
	@Override
	protected PromotionType thisPromotionType() {
		return PromotionType.SU_ZHAN_ZHI_WANG;
	}

	@Override
	public IRepository<Promotion026SpeedFight> getRepository() {
		return promotion026SpeedFightDao;
	}

	@Override
	protected void resetOnNewTurns(Promotion026SpeedFight promotion, PromotionControl control) {
		promotion.setRankCount(0);
		promotion.getTakeRewards().clear();
	}

	/**
	 * 记录速战次数
	 * @param rid
	 * @param productionId
	 */
	@Subscribe
	public void addSpeedCount(SpeedFightEvent event) {
		if(!promotionControlService.canRecordPromotionData(event.getRid(), thisPromotionType())) {
			return;
		}
		Promotion026SpeedFight promotion = this.getPromotionInfo(event.getRid());
		promotion.setRankCount(promotion.getRankCount() + 1);
		updatePromotion(promotion);
		
		eventBus.post(SpeedFightRankEvent.of(event.getRid(), promotion.getRankCount()));
	}

	@Override
	protected AbstractRankService thisRankService() {
		return speedFightRankService;
	}

	@Override
	protected Mail createPromotionRankMail(Promotion026SpeedFight promotionInfo, int rank) {
		CPromotion026SpeedFightRank cConfig = promotion026SpeedfightRankSysCache.getByTurnsRank(promotionInfo.getTurns(), rank);
		if(cConfig == null) {
			return null;
		}
		
		Mail mail = mailService.newMailNoTitle(promotionInfo.getRid(), MailScene.SU_ZHAN_ZHI_WANG_RANK,
				MailParams.build(rank), cConfig.getReward(), GameEvent.SU_ZHAN_ZHI_WANG_RANK);
		return mail;
	}
}
