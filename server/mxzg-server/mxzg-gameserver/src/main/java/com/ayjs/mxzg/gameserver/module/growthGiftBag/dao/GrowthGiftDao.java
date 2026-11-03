/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.growthGiftBag.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.growthGiftBag.domain.GrowthGift;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * @author YY
 *
 */
@Repository
public class GrowthGiftDao extends BaseRepository<GrowthGift> {


    public List<GrowthGift> selectAll(long rid){
        return  list("rid",rid);
    }

}
