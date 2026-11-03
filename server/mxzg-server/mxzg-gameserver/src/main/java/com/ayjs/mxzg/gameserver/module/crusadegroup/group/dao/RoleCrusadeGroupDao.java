/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.crusadegroup.group.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.RoleCrusadeGroup;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;


@Repository
public class RoleCrusadeGroupDao extends BaseRepository<RoleCrusadeGroup> {

    public RoleCrusadeGroup getOrCreate(long rid) {
        RoleCrusadeGroup roleCrusadeGroup = get(rid);
        if (roleCrusadeGroup == null) {
            synchronized (this) {
                roleCrusadeGroup = get(rid);
                if (roleCrusadeGroup == null) {
                    roleCrusadeGroup = new RoleCrusadeGroup();
                    roleCrusadeGroup.setRid(rid);
                    roleCrusadeGroup.setKnighthoodId(1);//默认1级
                    add(roleCrusadeGroup);
                }
            }
        }
        return roleCrusadeGroup;
    }

}
