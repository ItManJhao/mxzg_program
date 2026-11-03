/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.rank;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.annotation.Subscribe.AsyncType;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion028TavernInfo;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.TavernRankEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion028TavernInfoService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractPlayerRankService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;

/**
 * @author YY
 *
 */
@Observer
@Service
public class TavernRankService extends AbstractPlayerRankService {

	@Autowired
	private Promotion028TavernInfoService promotion028TavernInfoService;
	@Autowired
	private PromotionControlService promotionControlService;
	
	@Override
	public RankType getRankType() {
		return RankType.TAVERN;
	}
	
	@Subscribe(async = AsyncType.Async)
	private void listen(TavernRankEvent event) {
		Rank newRank = new Rank();
		newRank.setRankId(event.getRid());
		newRank.setRankTime(DateTimeUtil.currentSecond());
		newRank.setRankValue(event.getCount());
		topN.add(newRank);
	}

	@Override
	protected int getNotRankScore(Role role) {
		Promotion028TavernInfo promotion = promotion028TavernInfoService.getPromotionInfo(role.getId());
		return promotion.getRankCount();
	}

	@Override
	protected List<Rank> startLoadRank() {
		List<Rank> rankList = new ArrayList<>();
		
		PromotionControl promotionControl = promotionControlService.getControl(PromotionType.JIU_GUAN_CHANG_KE);
		for(Promotion028TavernInfo info : promotion028TavernInfoService.getAllPromotionInfo()) {
			if(info.getTurns() != promotionControl.getTurns() || info.getTurnsTime() != promotionControl.getTurnsTime()) {
				continue;
			}
			if(info.getRankCount() <= 0) {
				continue;
			}
			Rank rank = new Rank();
			rank.setRankId(info.getRid());
			rank.setRankValue(info.getRankCount());
			rank.setRankTime(info.getRankTime());
			rankList.add(rank);
		}
		
		return rankList;
	}
}
