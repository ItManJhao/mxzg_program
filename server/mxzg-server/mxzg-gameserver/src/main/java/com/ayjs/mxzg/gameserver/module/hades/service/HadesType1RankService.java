package com.ayjs.mxzg.gameserver.module.hades.service;

import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import org.springframework.stereotype.Service;

/**
 * @Author: CWJ
 * @Date: 2021/1/6
 **/
@Service
public class HadesType1RankService extends AbstractHadesRankService {
    @Override
    public RankType getRankType() {
        return RankType.HADES_TYPE_1;
    }

}
