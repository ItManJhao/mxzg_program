package com.ayjs.mxzg.gameserver.module.stagematch.battle.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.StageMatch;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;

/**
 * 段位赛信息
 */
@Repository
public class StageMatchDao extends BaseRepository<StageMatch> {

    private static final int UNIQUE_ID = 1;

    /**
     * 获取唯一实例
     * @return
     */
    public StageMatch get(){
        StageMatch stageMatch = get(UNIQUE_ID);
        if(stageMatch == null){
            stageMatch = new StageMatch();
            stageMatch.setId(UNIQUE_ID);
            stageMatch.setStartTime(LocalDateTime.now());
            stageMatch.setEndTime(LocalDateTime.now());
            add(stageMatch);
        }
        return stageMatch;
    }

}
