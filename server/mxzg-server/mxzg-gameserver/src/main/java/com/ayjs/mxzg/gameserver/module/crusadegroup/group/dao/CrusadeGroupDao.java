/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.crusadegroup.group.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.CrusadeGroup;
import org.springframework.stereotype.Repository;


@Repository
public class CrusadeGroupDao extends BaseRepository<CrusadeGroup> {

    private int DEFAULT_ID = 1;

    public CrusadeGroup get(){
        CrusadeGroup group = get(this.DEFAULT_ID);
        if(group == null){
            synchronized (this){
                group = get(this.DEFAULT_ID);
                if(group == null){
                    group = new CrusadeGroup();
                    group.setId(DEFAULT_ID);
                    add(group);
                }
            }
        }
        return group;
    }

}
