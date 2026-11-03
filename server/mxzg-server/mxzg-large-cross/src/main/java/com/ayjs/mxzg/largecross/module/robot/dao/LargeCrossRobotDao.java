package com.ayjs.mxzg.largecross.module.robot.dao;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.largecross.module.robot.domain.LargeCrossRobot;
import org.springframework.stereotype.Repository;


@Repository
public class LargeCrossRobotDao extends CacheAllDelayedJDBCRepository<LargeCrossRobot> {
}
