/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanwar.service;

import java.util.HashSet;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.cross.module.clanwar.dao.ClanWarCrossInfoDao;
import com.ayjs.mxzg.cross.module.clanwar.domain.ClanWarCrossInfo;

/**
 * @author YY
 *
 */
@Service
public class ClanWarCrossInfoService {

	@Autowired
	private ClanWarCrossInfoDao clanWarCrossInfoDao;
	
	public ClanWarCrossInfo getClanWarInfo(long clanId) {
		ClanWarCrossInfo warInfo = clanWarCrossInfoDao.get(clanId);
		if(warInfo == null) {
			warInfo = new ClanWarCrossInfo();
			warInfo.setClanId(clanId);
			warInfo.setRivalClanIds(new HashSet<>());
			clanWarCrossInfoDao.add(warInfo);
		}
		return warInfo;
	}
	
	public void update(ClanWarCrossInfo info) {
		clanWarCrossInfoDao.update(info);
	}
	
	public void update(List<ClanWarCrossInfo> list) {
		clanWarCrossInfoDao.update(list);
	}
}
