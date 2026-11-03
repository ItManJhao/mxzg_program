/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.welfare.service;

import com.ayjs.mxzg.gameserver.module.welfare.dao.GiftPackDayDao;
import com.ayjs.mxzg.gameserver.module.welfare.domain.GiftPackDay;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author YY
 *
 */
@Service
public class GiftPackDayService {

	@Autowired
	private GiftPackDayDao giftPackDayDao;
	
	public List<GiftPackDay> getGiftPackDays(long rid) {
		return giftPackDayDao.list("rid", rid);
	}
}
