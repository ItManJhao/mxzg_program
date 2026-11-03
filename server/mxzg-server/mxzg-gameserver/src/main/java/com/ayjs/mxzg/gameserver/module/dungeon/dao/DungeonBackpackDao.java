package com.ayjs.mxzg.gameserver.module.dungeon.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.dungeon.domain.DungeonBackpack;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class DungeonBackpackDao extends BaseRepository<DungeonBackpack> {

    /**
     * 查询庇护所背包所有道具
     *
     * @param rid
     */
    public List<DungeonBackpack> selectAll(long rid) {
        return list("rid", rid);
    }

}
