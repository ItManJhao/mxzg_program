/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.task.service;

import com.ayjs.mxzg.gameserver.module.task.dao.MidAutumnInfoDao;
import com.ayjs.mxzg.gameserver.module.task.domain.MidAutumnInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author YY
 *
 */
@Service
public class MidAutumnInfoService {

	@Autowired
	private MidAutumnInfoDao midAutumnInfoDao;
	
	public MidAutumnInfo getMidAutumnInfo(long rid) {
		MidAutumnInfo midAutumnInfo = midAutumnInfoDao.get(rid);
		if(midAutumnInfo == null) {
			midAutumnInfo = new MidAutumnInfo();
			midAutumnInfo.setRid(rid);
			midAutumnInfoDao.add(midAutumnInfo);
		}
		return midAutumnInfo;
	}
}
