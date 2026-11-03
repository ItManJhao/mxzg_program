/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.task.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.gameserver.module.task.dao.PromotionExchangeListDao;
import com.ayjs.mxzg.gameserver.module.task.domain.PromotionExchangeList;

/**
 * @author YY
 *
 */
@Service
public class PromotionExchangeListService {

	@Autowired
	private PromotionExchangeListDao promotionExchangeListDao;
	
	public List<PromotionExchangeList> getExchangeList(long rid) {
		return promotionExchangeListDao.list("rid", rid);
	}
}
