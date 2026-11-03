package com.ayjs.mxzg.largecross.module.promotion092.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.largecross.module.promotion092.domain.Promotion092Hero;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2021/3/11
 **/
@Repository
public class Promotion092HeroDao extends BaseRepository<Promotion092Hero> {

    public List<Promotion092Hero> listByTime(int time) {
        return list("startTime", time);
    }

}
