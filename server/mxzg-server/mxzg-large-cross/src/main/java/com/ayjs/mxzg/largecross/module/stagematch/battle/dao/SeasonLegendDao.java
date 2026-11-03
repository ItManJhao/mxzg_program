package com.ayjs.mxzg.largecross.module.stagematch.battle.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.SeasonLegend;
import org.springframework.stereotype.Repository;
import org.springframework.util.CollectionUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Repository
public class SeasonLegendDao extends BaseRepository<SeasonLegend> {

    /**
     *
     * @param groupId
     * @param season
     * @return
     */
    public SeasonLegend get(int groupId, int season){
        Map<String, Object> map = new HashMap<>();
        map.put("groupId", groupId);
        map.put("season", season);
        List<SeasonLegend> list = list(map);
        if(CollectionUtils.isEmpty(list)){
            return null;
        }
        return list.get(0);
    }

}
