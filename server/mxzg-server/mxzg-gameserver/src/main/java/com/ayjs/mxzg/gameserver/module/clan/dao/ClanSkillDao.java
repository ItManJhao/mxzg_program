/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.clan.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanSkill;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * @author YY
 *
 */
@Repository
public class ClanSkillDao extends BaseRepository<ClanSkill> {

	/**
	 * 查询玩家公会技能
	 * @param rid
	 * @return
	 */
	public List<ClanSkill> selectClanSkill(long rid){
		return list("rid", rid);
	}
	
}
