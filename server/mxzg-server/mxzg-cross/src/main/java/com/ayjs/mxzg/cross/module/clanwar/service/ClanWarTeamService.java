/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanwar.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.cross.module.clanwar.dao.ClanWarTeamDao;
import com.ayjs.mxzg.cross.module.clanwar.domain.ClanWarTeam;

/**
 * @author YY
 *
 */
@Service
public class ClanWarTeamService {

	@Autowired
	private ClanWarTeamDao clanWarTeamDao;
	
	public ClanWarTeam getClanWarTeam(long rid) {
		ClanWarTeam warTeam = clanWarTeamDao.get(rid);
		if(warTeam == null) {
			warTeam = new ClanWarTeam();
			warTeam.setRid(rid);
			clanWarTeamDao.add(warTeam);
		}
		return warTeam;
	}
	
	public void updateTeam(ClanWarTeam team) {
		clanWarTeamDao.update(team);
	}
	
	public void updateTeams(List<ClanWarTeam> list) {
		clanWarTeamDao.update(list);
	}
}
