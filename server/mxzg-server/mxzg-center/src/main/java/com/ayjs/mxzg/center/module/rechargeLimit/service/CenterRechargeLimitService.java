package com.ayjs.mxzg.center.module.rechargeLimit.service;

import com.ayjs.mxzg.center.module.rechargeLimit.dao.CenterRechargeLimitDao;
import com.ayjs.mxzg.center.module.rechargeLimit.domain.CenterRechargeLimit;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 中心服充值限制条件
 */
@Slf4j
@Service
public class CenterRechargeLimitService {

    @Autowired
    private CenterRechargeLimitDao centerRechargeLimitDao;

    public CenterRechargeLimit get() {
        return centerRechargeLimitDao.get();
    }

    public void updateRechargeLimit(CenterRechargeLimit rechargeLimit) {
        centerRechargeLimitDao.update(rechargeLimit);
    }

}
