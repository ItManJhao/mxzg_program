package com.ayjs.mxzg.gameserver.module.targetCounter.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.targetCounter.domain.TaskTargetCount;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2019/11/13
 **/
@Repository
public class TaskTargetCountDao extends BaseRepository<TaskTargetCount> {

    /***
     * 获取玩家所有实体
     * @param rid
     * @return
     */
    public List<TaskTargetCount> getAllByRid(long rid) {
        List<TaskTargetCount> allEntities = list("rid", rid);
        return allEntities;
    }

    /***
     * 获取玩家对应类型的实体
     * @param rid
     * @param type
     * @return
     */
    public List<TaskTargetCount> getEntityByType(long rid, int type) {
        List<TaskTargetCount> temps = getAllByRid(rid);
        return temps.stream().filter(operatorValue -> operatorValue.getType() == type).collect(Collectors.toList());
    }

}
