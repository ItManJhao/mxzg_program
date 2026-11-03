package com.ayjs.mxzg.gameserver.module.heroArrive.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.heroArrive.domain.TaskHeroArrive;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/11 21:08
 */
@Component
public class TaskHeroArriveDao extends BaseRepository<TaskHeroArrive> {

    /***
     * 获取玩家所有成就实体
     * @param rid
     * @return
     */
    public List<TaskHeroArrive> getAllByRid(long rid) {
        Map<String, Object> map = new HashMap<>();
        map.put("rid", rid);
        List<TaskHeroArrive> allAchievementTasks = list(map);
        return allAchievementTasks;
    }

}
