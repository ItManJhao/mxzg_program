package com.ayjs.mxzg.largecross.module.countryWar.dao;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarServer;
import org.springframework.stereotype.Repository;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Repository
public class CountryWarServerDao extends CacheAllDelayedJDBCRepository<CountryWarServer> {
}
