/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.task.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.task.dao.PromotionCycleCompleteDao;
import com.ayjs.mxzg.gameserver.module.task.domain.PromotionCycleComplete;

/**
 * @author YY
 *
 */
@Service
public class PromotionCycleCompleteService {
	
	@Autowired
	private PromotionCycleCompleteDao promotionCycleCompleteDao;
	
	public List<PromotionCycleComplete> getCycleCompletes(long rid) {
		return promotionCycleCompleteDao.list("rid", rid);
	}
	
	public PromotionCycleComplete getCycleComplete(long rid, PromotionType type) {
		PromotionCycleComplete result = null;
		for(PromotionCycleComplete obj : getCycleCompletes(rid)) {
			if(obj.getType() == type.getId()) {
				result = obj;
				break;
			}
		}
		if(result == null) {
			result = new PromotionCycleComplete();
			result.setRid(rid);
			result.setType(type.getId());
			result.setRound(1);
			promotionCycleCompleteDao.add(result);
		}
		return result;
	}
	
	public void updateCycleComplete(PromotionCycleComplete cycleComplete) {
		promotionCycleCompleteDao.update(cycleComplete);
	}
}
