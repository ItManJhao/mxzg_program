package com.ayjs.mxzg.largecross.module.stagematch.preliminaries.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.largecross.module.stagematch.preliminaries.domain.PreliminariesLadder;
import org.springframework.stereotype.Repository;

import java.util.Objects;

@Repository
public class PreliminariesLadderDao extends BaseRepository<PreliminariesLadder> {

    public PreliminariesLadder getOrCreate(long rid) {
        PreliminariesLadder ladder = get(rid);
        if (Objects.isNull(ladder)) {
            ladder = new PreliminariesLadder();
            ladder.setRid(rid);
            add(ladder);
        }

        return ladder;
    }

}
