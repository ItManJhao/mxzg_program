package com.ayjs.mxzg.gameserver.module.ladder.dao;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.gameserver.module.ladder.domain.LadderSuperiorBattle;
import org.springframework.stereotype.Repository;

/**
 * @Author: CWJ
 * @Date: 2020/1/3
 **/
@Repository
public class LadderSuperiorBattleDao extends CacheAllDelayedJDBCRepository<LadderSuperiorBattle> {

}
