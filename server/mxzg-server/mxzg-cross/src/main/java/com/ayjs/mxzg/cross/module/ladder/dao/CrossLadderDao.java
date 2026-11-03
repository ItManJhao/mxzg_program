package com.ayjs.mxzg.cross.module.ladder.dao;

import org.springframework.stereotype.Repository;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.cross.module.ladder.domain.CrossLadder;

@Repository
public class CrossLadderDao extends BaseRepository<CrossLadder> {

    public CrossLadder getCrossLadder(int group) {
        return get(group);
    }
}
