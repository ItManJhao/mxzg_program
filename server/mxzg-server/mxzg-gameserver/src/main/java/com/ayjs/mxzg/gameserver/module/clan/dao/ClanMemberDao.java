package com.ayjs.mxzg.gameserver.module.clan.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanMember;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class ClanMemberDao extends BaseRepository<ClanMember> {

    /**
     * 查询公会成员
     * @param clan_id
     * @return
     */
    public List<ClanMember> selectClanMember(long clan_id){
        return list("clanId",clan_id);
    }

   
}
