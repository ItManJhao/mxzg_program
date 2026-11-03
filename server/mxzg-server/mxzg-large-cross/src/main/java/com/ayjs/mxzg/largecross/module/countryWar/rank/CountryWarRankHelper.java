package com.ayjs.mxzg.largecross.module.countryWar.rank;

import com.ayjs.mxzg.common.base.IRegister;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2021/4/21
 **/
@Component
public class CountryWarRankHelper implements IRegister<AbstractCountryWarRankService> {

    private Map<CrossRankType, AbstractCountryWarRankService> map = new HashMap<>();

    @Override
    public void registerBean(AbstractCountryWarRankService bean) {
        AbstractCountryWarRankService old = map.put(bean.getRankType(), bean);
        if (old != null) {
            throw new RuntimeException("rank type repeated:" + bean.getRankType());
        }
    }

    public AbstractCountryWarRankService getByRankType(CrossRankType type) {
        return map.get(type);
    }
}
