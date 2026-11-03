package com.ayjs.mxzg.gameserver.module.targetCounter.counter;

import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.module.recharge.service.RoleRechargeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @Author: CWJ
 * @Date: 2019/11/18
 **/
@Service
public class TotalRechargeCounter implements Counter {

    @Autowired
    private RoleRechargeService roleRechargeService;

    @Override
    public TargetType thisType() {
        return TargetType.TOTAL_RECHARGE;
    }

    @Override
    public int count(long rid, TargetStruct targetStruct) {
        return (int) roleRechargeService.getRoleRecharge(rid).getTotalRecharge();
    }

    @Override
    public long taskCount(long rid, TargetStruct targetStruct) {
        return count(rid, targetStruct);
    }
}
