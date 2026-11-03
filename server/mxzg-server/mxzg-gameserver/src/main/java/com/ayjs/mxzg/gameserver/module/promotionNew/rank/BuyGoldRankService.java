/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.rank;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.annotation.Subscribe.AsyncType;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion025BuyGold;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.BuyGoldRankEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion025BuyGoldService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractPlayerRankService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * @author YY
 *
 */
@Observer
@Service
public class BuyGoldRankService extends AbstractPlayerRankService {

    @Autowired
    private Promotion025BuyGoldService promotion025BuyGoldService;
    @Autowired
    private PromotionControlService promotionControlService;

    @Override
    public RankType getRankType() {
        return RankType.BUY_GOLD;
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(BuyGoldRankEvent event) {
//        Rank newRank = new Rank();
//        newRank.setRankId(event.getRid());
//        newRank.setRankTime(DateTimeUtil.currentSecond());
//        newRank.setRankValue(event.getCount());
//        topN.add(newRank);
        Promotion025BuyGold promotion = promotion025BuyGoldService.getPromotionInfo(event.getRid());
        topN.add(buildRankData(promotion));
    }

    @Override
    protected int getNotRankScore(Role role) {
        Promotion025BuyGold promotion = promotion025BuyGoldService.getPromotionInfo(role.getId());
        return promotion.getRankCount();
    }

    @Override
    protected List<Rank> startLoadRank() {
        List<Rank> list = new ArrayList<>();
        PromotionControl control = promotionControlService.getControl(PromotionType.DIAN_SHI_CHENG_JIN);
        promotion025BuyGoldService.getAll().stream().forEach(entity -> {
        	if (control.getTurns() != entity.getTurns() || control.getTurnsTime() != entity.getTurnsTime()) {
            	return;
            }
            if(entity.getRankCount() <= 0) {
            	return;
            }
            list.add(buildRankData(entity));
        });
        return list;
    }

    private Rank buildRankData(Promotion025BuyGold entity) {
        Rank rank = new Rank();
        rank.setRankValue(entity.getRankCount());
        rank.setRankId(entity.getRid());
        rank.setRankTime(entity.getRankTime());
        return rank;
    }
}
