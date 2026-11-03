package com.ayjs.mxzg.gameserver.module.operatorValue.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.operatorValue.domain.OperatorValue;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @description: 玩家操作统计，累计玩家的操作计数
 * @author: CWJ
 * @date: 2019/10/14 10:08
 */
@Repository
public class OperatorValueDao extends BaseRepository<OperatorValue> {
    /***
     * 获取玩家所有实体
     * @param rid
     * @return
     */
    public List<OperatorValue> getAllByRid(long rid) {
        Map<String, Object> map = new HashMap<>();
        map.put("rid", rid);
        List<OperatorValue> allStatisticss = list(map);
        return allStatisticss;
    }

    /***
     * 获取玩家对应类型的实体
     * @param rid
     * @param type
     * @return
     */
    public OperatorValue getOperatorValueByType(long rid, int type) {
        List<OperatorValue> temps = getAllByRid(rid);
        if (temps == null || temps.isEmpty()) {
            return null;
        }
        return temps.stream().filter(operatorValue -> operatorValue.getType() == type).findFirst().orElse(null);
    }

    public int getCountByType(long rid, int type) {
        OperatorValue operatorValue = getOperatorValueByType(rid, type);
        return operatorValue == null ? 0 : operatorValue.getCount();
    }
}
