/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.clanwar.service;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.gameserver.module.clanwar.dao.ClanWarInfoDao;
import com.ayjs.mxzg.gameserver.module.clanwar.domain.ClanWarInfo;

/**
 * @author YY
 *
 */
@Service
public class ClanWarInfoService {
	
	@Autowired
	private ClanWarInfoDao clanWarInfoDao;
	
	public ClanWarInfo getClanWarInfo(long clanId) {
		ClanWarInfo warInfo = clanWarInfoDao.get(clanId);
		if(warInfo == null) {
			warInfo = new ClanWarInfo();
			warInfo.setClanId(clanId);
			warInfo.setBattleMembers(new HashSet<>());
			warInfo.setBoxMember(new HashMap<>());
			clanWarInfoDao.add(warInfo);
		}
		return warInfo;
	}
	
	public void updateClanWarInfo(ClanWarInfo info) {
		clanWarInfoDao.update(info);
	}
	
	public void updateClanWarInfos(List<ClanWarInfo> list) {
		clanWarInfoDao.update(list);
	}
	
	public List<ClanWarInfo> getAllWarInfo() {
		return clanWarInfoDao.listAll();
	}
}
