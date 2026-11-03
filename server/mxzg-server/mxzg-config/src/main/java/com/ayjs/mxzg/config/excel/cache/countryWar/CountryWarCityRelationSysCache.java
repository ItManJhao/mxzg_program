package com.ayjs.mxzg.config.excel.cache.countryWar;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.countrywar.CCountryWarCityRelation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Component
public class CountryWarCityRelationSysCache extends BaseExcelCache<CCountryWarCityRelation> {

    public Map<Integer,Map<Integer,List<List<Integer>>>> map;

    @Autowired
    private CountryWarCitySysCache countryWarCitySysCache;

    @Override
    public void loadAfterAllReady() {

//        List<CCountryWarCity> list = countryWarCitySysCache.getAll().stream().filter(config -> config.getType() == 1).collect(Collectors.toList());
//        Map<Integer,Map<Integer,List<List<Integer>>>> _map=new HashMap<>();
//        list.forEach(config->{
//            CCountryWarCityRelation relationConfig = getOrThrow(config.getIdx());
//            Map<Integer, List<List<Integer>>> cityMap = _map.computeIfAbsent(config.getIdx(), key -> new HashMap<>());
//            relationConfig.getConnect_city_id().forEach(cityId->{
//                cityMap.computeIfAbsent(cityId,key->new ArrayList<>()).add()
//            });
//        });
//        getAll().stream().collect(Collectors.groupingBy(CCountryWarCityRelation::getCity_id));
    }


    @Override
    public String getFileName() {
        return "countrywarcityrelation";
    }
}
