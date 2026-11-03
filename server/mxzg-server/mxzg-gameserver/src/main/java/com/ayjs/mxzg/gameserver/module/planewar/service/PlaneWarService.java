package com.ayjs.mxzg.gameserver.module.planewar.service;

import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.planewar.PlaneWarConst;
import com.ayjs.mxzg.config.excel.cache.planewar.PlaneWarHeroSysCache;
import com.ayjs.mxzg.config.struct.ThingBonus;
import com.ayjs.mxzg.gameserver.module.planewar.dao.PlaneWarDao;
import com.ayjs.mxzg.gameserver.module.planewar.dao.PlaneWarTurnDao;
import com.ayjs.mxzg.gameserver.module.planewar.domain.PlaneWar;
import com.ayjs.mxzg.gameserver.module.planewar.domain.PlaneWarTurn;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PrivilegeEffectType;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion010PrivilegeGiftService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Objects;

/**
 * @Author: CWJ
 * @Date: 2020/9/15
 **/
@Service
public class PlaneWarService {

    @Autowired
    private PlaneWarDao planeWarDao;
    @Autowired
    private PlaneWarConst planeWarConst;
    @Autowired
    private PlaneWarTurnDao planeWarTurnDao;
    @Autowired
    private PlaneWarHeroSysCache planeWarHeroSysCache;

    public PlaneWar get(long rid) {
        PlaneWar planeWar = planeWarDao.get(rid);
        if (Objects.isNull(planeWar)) {
            planeWar = new PlaneWar();
            planeWar.setRid(rid);
            planeWar.getAfter();
            planeWarDao.add(planeWar);
        }
        planeWarDao.update(planeWar);
        return planeWar;
    }

    public PlaneWarTurn getTurn() {
        PlaneWarTurn planeWarTurn = planeWarTurnDao.get(1l);
        if (Objects.isNull(planeWarTurn)) {
            planeWarTurn = new PlaneWarTurn();
            planeWarTurn.setId(1);
            planeWarTurnDao.add(planeWarTurn);
        }

        LocalDate now = LocalDate.now();
        if (!LocalDateTimeUtil.isSameWeek(planeWarTurn.getTurnResetTime(), now)) {
            planeWarTurn.setTurn(planeWarTurn.getTurn() + 1);
            if (planeWarTurn.getTurn() > planeWarHeroSysCache.getMaxTurn()) {
                planeWarTurn.setTurn(planeWarTurn.getTurn() - planeWarHeroSysCache.getMaxTurn());
            }
            planeWarTurn.setTurnResetTime(now);
            planeWarTurnDao.update(planeWarTurn);
        }
        return planeWarTurn;
    }

    public void update(PlaneWar entity) {
        planeWarDao.update(entity);
    }

    @Autowired
    private Promotion010PrivilegeGiftService promotion010PrivilegeGiftService;

    public int getFreeMaxCount(long rid) {
        List<ThingBonus> privilegeBonus = promotion010PrivilegeGiftService.getPrivilegeBonus(rid, PrivilegeEffectType.PLANE_WAR_FREE);
        return privilegeBonus.size() == 0 ? planeWarConst.getFreeChallengeCount() :
                planeWarConst.getFreeChallengeCount() + privilegeBonus.stream().mapToInt(ThingBonus::getBonus).sum();
    }

    public int getBuyMaxCount(long rid) {
        List<ThingBonus> privilegeBonus = promotion010PrivilegeGiftService.getPrivilegeBonus(rid, PrivilegeEffectType.PLANE_WAR_BUY);
        return privilegeBonus.size() == 0 ? planeWarConst.getMaxBuyCount() :
                planeWarConst.getMaxBuyCount() + privilegeBonus.stream().mapToInt(ThingBonus::getBonus).sum();
    }

    public int getRemainingChallengeCount(PlaneWar planeWar) {
        return planeWar.getHadBuyCount() + getFreeMaxCount(planeWar.getRid()) - planeWar.getHadChallengeCount();
    }

    public int getRemainingBuyCount(PlaneWar planeWar) {
        return getBuyMaxCount(planeWar.getRid()) - planeWar.getHadBuyCount();
    }
}
