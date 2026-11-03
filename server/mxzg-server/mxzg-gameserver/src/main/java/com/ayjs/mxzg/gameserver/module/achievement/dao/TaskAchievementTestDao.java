package com.ayjs.mxzg.gameserver.module.achievement.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.achievement.domain.TaskAchievementTest;
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
public class TaskAchievementTestDao extends BaseRepository<TaskAchievementTest> {

    /***
     * 获取玩家所有成就实体
     * @param rid
     * @return
     */
    public List<TaskAchievementTest> getAllByRid(long rid) {
        Map<String, Object> map = new HashMap<>();
        map.put("rid", rid);
        List<TaskAchievementTest> allAchievementTasks = list(map);
        return allAchievementTasks;
    }

    /***
     * 获取玩家对应成就类型的实体
     * @param rid
     * @param idx
     * @return
     */
    public TaskAchievementTest getTaskByIdx(long rid, int idx) {
        List<TaskAchievementTest> temps = getAllByRid(rid);
        return temps.stream().filter(entity -> entity.getCurrTask() == idx).findFirst().orElse(null);
    }

}
