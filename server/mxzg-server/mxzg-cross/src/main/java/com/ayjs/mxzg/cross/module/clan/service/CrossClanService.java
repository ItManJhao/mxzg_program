/**
 * 
 */
package com.ayjs.mxzg.cross.module.clan.service;

import com.ayjs.mxzg.cross.module.clan.dao.CrossClanDao;
import com.ayjs.mxzg.cross.module.clan.domain.CrossClan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author YY
 *
 */
@Service
public class CrossClanService {
	
	@Autowired
	private CrossClanDao crossClanDao;

	public CrossClan get(long clanId) {
		if (clanId <= 0){
			System.out.println("clanId:" + clanId);
			return null;
		}
		return crossClanDao.get(clanId);
	}


	public CrossClan getOrThrow(long clanId) {
		CrossClan clan = get(clanId);
		if(clan == null) {
			throw new NullPointerException("cross clan is null clanId:" + clanId);
		}
		return clan;
	}


	public List<CrossClan> getAllClan() {
		return crossClanDao.listAll();
	}
}
