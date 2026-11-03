package com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.domain.PreliminariesRecord;
import org.springframework.stereotype.Repository;

/**
 * 巅峰赛记录
 */
@Repository
public class PreliminariesRecordDao extends BaseRepository<PreliminariesRecord> {

    public PreliminariesRecord getOrCreate(long rid){
        PreliminariesRecord preliminariesRecord = get(rid);
        if(preliminariesRecord == null){
            preliminariesRecord = new PreliminariesRecord();
            preliminariesRecord.setRid(rid);
            add(preliminariesRecord);
        }
        return preliminariesRecord;
    }

}
