package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion073Dao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion073;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.recharge.dao.RoleRechargeDao;
import com.ayjs.mxzg.gameserver.module.recharge.domain.RoleRecharge;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/8/6
 **/
@Service
@Slf4j
public class Promotion073Service extends BasePromotionService<Promotion073> {

    @Autowired
    private Promotion073Dao promotion073Dao;
    @Autowired
    private RoleRechargeDao roleRechargeDao;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.RESET_NORMAL_DOUBLE;
    }

    @Override
    public IRepository<Promotion073> getRepository() {
        return promotion073Dao;
    }

    @Override
    protected void resetOnNewTurns(Promotion073 promotion, PromotionControl control) {
    }

    @Override
    public void handleOnPromotionNewTurns(PromotionControl control) {
        List<RoleRecharge> roleRecharges = roleRechargeDao.listAll();
        roleRecharges.forEach(roleRecharge -> roleRecharge.getChargedInfo().clear());
        roleRechargeDao.update(roleRecharges);
    }
}
