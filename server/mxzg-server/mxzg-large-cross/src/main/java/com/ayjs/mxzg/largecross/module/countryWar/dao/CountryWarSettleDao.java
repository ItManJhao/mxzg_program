package com.ayjs.mxzg.largecross.module.countryWar.dao;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarSettle;
import org.springframework.stereotype.Repository;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Repository
public class CountryWarSettleDao extends CacheAllDelayedJDBCRepository<CountryWarSettle> {

    public CountryWarSettle get(int round) {
        CountryWarSettle entity = super.get(round);
        if (entity == null) {
            entity = new CountryWarSettle();
            entity.setRound(round);
            add(entity);
        }
        return entity;
    }
}
