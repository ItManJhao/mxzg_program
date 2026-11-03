package com.ayjs.mxzg.gameserver.module.fetter.dao;


import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.fetter.domain.FetterGoddess;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class FetterGoddessDao extends BaseRepository<FetterGoddess> {


    /**
     * 查询羁绊女神
     *
     * @param rid
     * @return
     */
    public List<FetterGoddess> select(long rid) {
        return list("rid", rid);
    }

    /**
     * 查询某个羁绊女神
     *
     * @param rid
     * @param goddess_type
     * @return
     */
    public FetterGoddess selectFetterGoddess(long rid, int goddess_type) {
        FetterGoddess fetterGoddess = null;
        for (FetterGoddess model : select(rid)) {
            if (model.getGoddessType() == goddess_type) {
                fetterGoddess = model;
            }
        }
        return fetterGoddess;
    }
}
