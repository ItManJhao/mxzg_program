package com.ayjs.mxzg.largecross.module.countryWar.dao;

import com.ayjs.mxzg.common.persistence.repository.CacheAllDelayedJDBCRepository;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarRole;
import com.ayjs.mxzg.largecross.module.countryWar.domain.CountryWarTime;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Repository
@Slf4j
public class CountryWarRoleDao extends CacheAllDelayedJDBCRepository<CountryWarRole> {

    @Autowired
    private CountryWarTimeDao countryWarTimeDao;

    public CountryWarRole get(long id) {
        if (id == 0) {
            log.error("id=" + id, new Exception());
            return null;
        }
        CountryWarRole entity = super.get(id);
        if (entity == null) {
            entity = new CountryWarRole();
            entity.setRid(id);
            add(entity);
        }
        CountryWarTime time = countryWarTimeDao.getSingle();
        if (entity.getRound() != time.getRound()) {
            entity.setOccupyCity(0);
            entity.setDefendCity(0);
            entity.setDamage(0);
            entity.setKillCount(0);
            entity.setRound(time.getRound());
            entity.getLogs().clear();
            update(entity);
        }
        return entity;
    }
}
