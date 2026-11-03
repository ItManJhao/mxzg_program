package com.ayjs.mxzg.gameserver.module.countryWar.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.countryWar.domain.CountryWarSystem;
import org.springframework.stereotype.Repository;

/**
 * @Author: CWJ
 * @Date: 2021/4/19
 **/
@Repository
public class CountryWarSystemDao extends BaseRepository<CountryWarSystem> {

    public CountryWarSystem getSingle() {
        CountryWarSystem entity = get(1);
        if (entity == null) {
            entity = new CountryWarSystem();
            entity.setId(1);
            add(entity);
        }
        return entity;
    }
}
