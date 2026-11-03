package com.ayjs.mxzg.gameserver.module.clan.dao;

import org.springframework.stereotype.Repository;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanBoss;

@Repository
public class ClanBossDao extends BaseRepository<ClanBoss> {

	/**
	 *
	 * @param clan_id
	 * @return
	 */
	public ClanBoss select(long clan_id) {
		return get(clan_id);
	}

}
