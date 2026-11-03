/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.welfare.service;

import com.ayjs.mxzg.gameserver.module.welfare.dao.GiftPackMonthDao;
import com.ayjs.mxzg.gameserver.module.welfare.domain.GiftPackMonth;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author YY
 *
 */
@Service
public class GiftPackMonthService {

	@Autowired
	private GiftPackMonthDao giftPackMonthDao;
	
	public List<GiftPackMonth> getGiftPackMonths(long rid) {
		return giftPackMonthDao.list("rid", rid);
	}
}
