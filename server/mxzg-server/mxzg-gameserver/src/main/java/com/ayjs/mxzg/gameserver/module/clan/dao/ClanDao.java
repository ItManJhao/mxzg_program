package com.ayjs.mxzg.gameserver.module.clan.dao;


import org.springframework.stereotype.Repository;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;

@Repository
public class ClanDao extends CacheAllDelayedJDBCRepository<Clan> {
	
	/*private ConcurrentMap<Long, String> id2Name = null;
	private ReentrantLock lock = new ReentrantLock();
	
	
	@Override
	public void add(Clan entity) {
		super.add(entity);
		getName2Id().put(entity.getId(), entity.getClanName());
	}

	@Override
	public void remove(Clan entity) {
		super.remove(entity);
		getName2Id().put(entity.getId(), entity.getClanName());
	}

	public ConcurrentMap<Long, String> getName2Id() {
		if (id2Name == null) {
			lock.lock();
			if (id2Name != null) {
				lock.unlock();
				return id2Name;
			}
			List<Clan> temp = listAll();
			id2Name = new ConcurrentHashMap<Long, String>();
			temp.stream().forEach(clan -> id2Name.put(clan.getId(), clan.getClanName()));
			lock.unlock();
		}
		return id2Name;

	}*/

}
