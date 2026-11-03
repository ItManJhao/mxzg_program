package com.ayjs.mxzg.cross.module.crusadegroup.group.dao;

import com.ayjs.mxzg.cross.module.crusadegroup.group.domain.CrusadeSystem;
import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import org.springframework.stereotype.Repository;

@Repository
public class CrusadeSystemDao extends BaseRepository<CrusadeSystem> {

    private static int DEFAULT_UNIQUE_ID = 1;

    public CrusadeSystem get(){
        CrusadeSystem system = get(DEFAULT_UNIQUE_ID);
        if(system == null){
            synchronized (this){
                system = get(DEFAULT_UNIQUE_ID);
                if(system == null){
                    system = new CrusadeSystem();
                    system.setId(DEFAULT_UNIQUE_ID);
                    add(system);
                }
            }
        }
        return system;
    }

}
