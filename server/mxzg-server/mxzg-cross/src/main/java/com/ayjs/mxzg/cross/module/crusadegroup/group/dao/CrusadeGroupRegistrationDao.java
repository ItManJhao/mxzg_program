package com.ayjs.mxzg.cross.module.crusadegroup.group.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.cross.module.crusadegroup.group.domain.CrusadeGroupRegistration;
import org.springframework.stereotype.Repository;

@Repository
public class CrusadeGroupRegistrationDao extends BaseRepository<CrusadeGroupRegistration> {


    public CrusadeGroupRegistration getOrCreate(int serverId){
        CrusadeGroupRegistration registration = get(serverId);
        if(registration == null){
            synchronized (this){
                registration = get(serverId);
                if(registration == null){
                    registration = new CrusadeGroupRegistration();
                    registration.setId(serverId);
                    add(registration);
                }
            }
        }
        return registration;
    }

}
