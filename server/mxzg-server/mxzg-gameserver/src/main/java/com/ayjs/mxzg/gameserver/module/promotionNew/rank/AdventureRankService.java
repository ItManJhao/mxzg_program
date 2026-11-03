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
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion027Adventure;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.AdventureRankEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion027AdventureService;
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
public class AdventureRankService extends AbstractPlayerRankService {

    @Autowired
    private Promotion027AdventureService promotion027AdventureService;
    @Autowired
    private PromotionControlService promotionControlService;

    @Override
    public RankType getRankType() {
        return RankType.ADVENTURE;
    }

    @Subscribe(async = AsyncType.Async)
    private void listen(AdventureRankEvent event) {
//        Rank newRank = new Rank();
//        newRank.setRankId(event.getRid());
//        newRank.setRankTime(DateTimeUtil.currentSecond());
//        newRank.setRankValue(event.getCount());
//        topN.add(newRank);

        Promotion027Adventure promotion = promotion027AdventureService.getPromotionInfo(event.getRid());
        topN.add(buildRankData(promotion));
    }

    @Override
    protected int getNotRankScore(Role role) {
        Promotion027Adventure promotion = promotion027AdventureService.getPromotionInfo(role.getId());
        return promotion.getRankCount();
    }

    @Override
    protected List<Rank> startLoadRank() {
        List<Rank> list = new ArrayList<>();
        PromotionControl control = promotionControlService.getControl(PromotionType.SHI_LIAN_ZHI_LU);
        promotion027AdventureService.getAll().stream().forEach(entity -> {
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

    private Rank buildRankData(Promotion027Adventure entity) {
        Rank rank = new Rank();
        rank.setRankValue(entity.getRankCount());
        rank.setRankId(entity.getRid());
        rank.setRankTime(entity.getRankTime());
        return rank;
    }
}
