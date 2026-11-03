package com.ayjs.mxzg.gameserver.module.stagematch.battle.dao;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.domain.PreliminariesSuperiorBattle;
import org.springframework.stereotype.Repository;


@Repository
public class PinnacleSuperiorBattleDao extends CacheAllDelayedJDBCRepository<PreliminariesSuperiorBattle> {

}
