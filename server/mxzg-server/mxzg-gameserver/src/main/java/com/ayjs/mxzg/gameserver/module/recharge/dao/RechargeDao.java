package com.ayjs.mxzg.gameserver.module.recharge.dao;

import com.ayjs.mxzg.common.persistence.repository.JDBCRepository;
import com.ayjs.mxzg.gameserver.module.recharge.domain.Recharge;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2019/10/18
 **/
@Repository
public class RechargeDao extends JDBCRepository<Recharge> {

    public List<Recharge> getAllByRid(long rid) {
        Map<String, Object> map = new HashMap<>();
        map.put("rid", rid);
        List<Recharge> all = list(map);
        return all;
    }

    public Recharge getByPlatformOrderId(String platformOrderId) {
        Map<String, Object> map = new HashMap<>();
        map.put("platformOrderId", platformOrderId);
        List<Recharge> all = list(map);
        if (all.isEmpty()) {
            return null;
        }
        return all.get(0);
    }
}
