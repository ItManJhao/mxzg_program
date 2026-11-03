package com.ayjs.mxzg.largecross.module.hades.service;

import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.largecross.module.hades.dao.CrossHadesDao;
import com.ayjs.mxzg.largecross.module.hades.domain.CrossHades;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.mxzg.protocol.HadesGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2021/1/5
 **/
@Service
public class CrossHadesService {
    @Autowired
    private CrossHadesDao crossHadesDao;

    public CrossHades get(long rid) {
        Asserts.isTrue(rid != 0, ErrorCode.ROLE_NOT_EXIST.getValue(), String.format("rid[%s] error", rid));
        CrossHades crossHades = crossHadesDao.get(rid);
        if (crossHades == null) {
            crossHades = new CrossHades();
            crossHades.setRid(rid);
            crossHadesDao.add(crossHades);
        }
        return crossHades;
    }

    public void update(CrossHades crossHades) {
        crossHadesDao.update(crossHades);
    }

    public List<CrossHades> listAll() {
        return crossHadesDao.listAll();
    }

    public CrossRankType hadesType2RankType(HadesGMsg.HadesType hadesType) {
        if (hadesType == HadesGMsg.HadesType.hades_type_1) {
            return CrossRankType.HADES_TYPE_1;
        }
        return CrossRankType.HADES_TYPE_2;
    }

    public HadesGMsg.HadesType RankType2HadesType(CrossRankType rankType) {
        if (rankType == CrossRankType.HADES_TYPE_1) {
            return HadesGMsg.HadesType.hades_type_1;
        }
        return HadesGMsg.HadesType.hades_type_2;
    }
}
