package com.ayjs.mxzg.gameserver.module.hades.service;

import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.gameserver.module.hades.dao.HadesDao;
import com.ayjs.mxzg.gameserver.module.hades.domain.Hades;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.protocol.HadesGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;

/**
 * @Author: CWJ
 * @Date: 2021/1/5
 **/
@Service
public class HadesService {
    @Autowired
    private HadesDao hadesDao;

    public Hades get(long rid) {
        Asserts.isTrue(rid != 0, ErrorCode.ROLE_NOT_EXIST.getValue(), String.format("rid[%s] error", rid));
        Hades hades = hadesDao.get(rid);
        if (hades == null) {
            hades = new Hades();
            hades.setRid(rid);
            hadesDao.add(hades);
        }
        if (!LocalDate.now().isEqual(hades.getCountRefresh())) {
            hades.setCountRefresh(LocalDate.now());
            hades.setSweepCount(0);
            hadesDao.update(hades);
        }
        return hades;
    }

    public void update(Hades hades) {
        hadesDao.update(hades);
    }

    public RankType hadesType2RankType(HadesGMsg.HadesType hadesType) {
        if (hadesType == HadesGMsg.HadesType.hades_type_1) {
            return RankType.HADES_TYPE_1;
        }
        return RankType.HADES_TYPE_2;
    }

    public HadesGMsg.HadesType rankType2HadesType(RankType rankType) {
        if (rankType == RankType.HADES_TYPE_1) {
            return HadesGMsg.HadesType.hades_type_1;
        }
        return HadesGMsg.HadesType.hades_type_2;
    }
}
