package com.ayjs.mxzg.gameserver.module.teamArena.dao;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.gameserver.module.teamArena.domain.ArenaTeam;
import org.springframework.stereotype.Repository;

/**
 * @Author: CWJ
 * @Date: 2020/4/9
 **/
@Repository
public class ArenaTeamDao extends CacheAllDelayedJDBCRepository<ArenaTeam> {
}
