package com.ayjs.mxzg.config.excel.cache;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CHeroPalace;
import com.google.common.collect.ImmutableSet;

/**
 * @Author: CWJ
 * @Date: 2020/3/24
 **/
@Component
public class HeroPalaceSysCache extends BaseExcelCache<CHeroPalace> {

    private Map<Integer, Map<Integer, CHeroPalace>> typeMap = null;

    public Map<Integer, List<CHeroPalace>> elemMap = null;

    @Override
    protected void loadAfterReady() {
        Map<Integer, List<CHeroPalace>> collect = getAll().stream().collect(Collectors.groupingBy(CHeroPalace::getType));
        Map<Integer, Map<Integer, CHeroPalace>> typeMap_ = new HashMap<>();
        collect.forEach((key, value) -> {
            typeMap_.put(key, value.stream().collect(Collectors.toMap(CHeroPalace::getRank, Function.identity())));
        });
        typeMap = typeMap_;

        elemMap = getAll().stream().collect(Collectors.groupingBy(CHeroPalace::getElem));
    }

    public Set<Integer> getAllType() {
        return ImmutableSet.copyOf(typeMap.keySet());
    }

    public Map<Integer, CHeroPalace> getAllByType(int type) {
        return typeMap.get(type);
    }

    public List<CHeroPalace> getAllByElem(int elem) {
        return elemMap.get(elem);
    }

    @Override
    public String getFileName() {
        return "heropalace";
    }
}
