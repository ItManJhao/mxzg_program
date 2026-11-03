package com.ayjs.mxzg.center.module.rechargeLimit.dao;

import com.ayjs.mxzg.center.module.rechargeLimit.domain.CenterRechargeLimit;
import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

import java.util.HashSet;

/**
 * 跨服充值限制条件
 */
@Slf4j
@Repository
public class CenterRechargeLimitDao extends BaseRepository<CenterRechargeLimit> {
    /**
     * 唯一主键id
     */
    private final int UNIQUE_ID = 1;

    /**
     * 获取充值限制条件
     *
     * @return
     */
    public CenterRechargeLimit get() {
        CenterRechargeLimit rechargeLimit = get(UNIQUE_ID);
        if (rechargeLimit == null) {
            rechargeLimit = new CenterRechargeLimit();
            rechargeLimit.setId(UNIQUE_ID);
            rechargeLimit.setTotalRecharge(0);
            rechargeLimit.setAreas(new HashSet<>());
            rechargeLimit.setLoginAreas(new HashSet<>());
            add(rechargeLimit);
        }
        return rechargeLimit;
    }
}
