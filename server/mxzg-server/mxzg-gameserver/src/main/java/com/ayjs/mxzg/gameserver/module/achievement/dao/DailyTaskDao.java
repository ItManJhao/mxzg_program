package com.ayjs.mxzg.gameserver.module.achievement.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.achievement.domain.DailyTask;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/12 16:45
 */
@Component
public class DailyTaskDao extends BaseRepository<DailyTask> {

    /***
     * 获取玩家所有成就实体
     * @param rid
     * @return
     */
    public List<DailyTask> getAllByRid(long rid) {
        Map<String, Object> map = new HashMap<>();
        map.put("rid", rid);
        List<DailyTask> allAchievements = list(map);
        return allAchievements;
    }

//    /***
//     * 获取玩家对应目标类型的实体
//     * @param rid
//     * @param type
//     * @return
//     */
//    public DailyTask getTaskByType(long rid, int type) {
//        List<DailyTask> temps = getAllByRid(rid);
//        if (temps == null || temps.isEmpty()) {
//            return null;
//        }
//        return temps.get(0);
//    }
}
