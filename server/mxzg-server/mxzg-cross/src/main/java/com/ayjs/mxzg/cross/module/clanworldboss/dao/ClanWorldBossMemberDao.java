/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanworldboss.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.cross.module.clanworldboss.domain.ClanWorldBossMember;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * @author YY
 *
 */
@Repository
public class ClanWorldBossMemberDao extends BaseRepository<ClanWorldBossMember> {

    public List<ClanWorldBossMember> getByRound(int round) {
        return list("round", round);
    }

}
