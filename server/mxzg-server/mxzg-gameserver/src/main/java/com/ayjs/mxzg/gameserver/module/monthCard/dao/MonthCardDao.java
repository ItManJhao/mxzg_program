package com.ayjs.mxzg.gameserver.module.monthCard.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.common.persistence.repository.CachedJDBCRepository;
import com.ayjs.mxzg.gameserver.module.monthCard.domain.MonthCard;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2019/10/16
 **/
@Repository
public class MonthCardDao extends BaseRepository<MonthCard> {

    public List<MonthCard> getAllById(long rid) {
        Map<String, Object> map = new HashMap<>();
        map.put("rid", rid);
        List<MonthCard> all = list(map);
        return all;
    }
}
