/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.blessingPool.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.blessingPool.domain.BlessingPool;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 许愿池
 *
 */
@Repository
public class BlessingPoolDao extends BaseRepository<BlessingPool> {

    public List<BlessingPool> getBlessingPool(long rid) {
        return list("rid", rid);
    }
}
