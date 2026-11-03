package com.ayjs.mxzg.cross.module.ladder.dao;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.cross.module.ladder.domain.CrossLadderRobot;
import org.springframework.stereotype.Repository;

/**
 * 跨服天梯机器人
 */
@Repository
public class CrossLadderRobotDao extends CacheAllDelayedJDBCRepository<CrossLadderRobot> {
}
