package com.ayjs.mxzg.largecross.module.countryWar.dao;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.common.util.InternerPool;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarTime;
import org.springframework.stereotype.Repository;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Repository
public class CountryWarTimeDao extends CacheAllDelayedJDBCRepository<CountryWarTime> {

    public CountryWarTime getSingle() {
        CountryWarTime single = get(1);
        if (single == null) {
            synchronized (InternerPool.intern("create_country_war_time")) {
                single = get(1);
                if (single == null) {
                    single = new CountryWarTime();
                    single.setId(1);
                    single.setHadSettle(true);
                    single.setGroupIndex(1);
                    add(single);
                }
            }
        }
        return single;
    }

    public void updateSingle() {
        update(getSingle());
    }
}
