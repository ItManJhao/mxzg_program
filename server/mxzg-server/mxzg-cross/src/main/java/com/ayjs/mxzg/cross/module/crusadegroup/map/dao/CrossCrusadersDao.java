package com.ayjs.mxzg.cross.module.crusadegroup.map.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.cross.module.crusadegroup.map.domain.CrossCrusaders;
import org.springframework.stereotype.Repository;

@Repository
public class CrossCrusadersDao extends BaseRepository<CrossCrusaders> {

    public CrossCrusaders getOrCreate(long rid){
        CrossCrusaders crossCrusaders = get(rid);
        if(crossCrusaders == null){
            synchronized (this){
                crossCrusaders = get(rid);
                if(crossCrusaders == null){
                    crossCrusaders = new CrossCrusaders();
                    crossCrusaders.setRid(rid);
                    add(crossCrusaders);
                }
            }
        }
        return crossCrusaders;
    }

}
