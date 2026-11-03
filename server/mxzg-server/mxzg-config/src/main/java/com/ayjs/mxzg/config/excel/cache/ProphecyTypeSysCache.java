package com.ayjs.mxzg.config.excel.cache;


import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.config.excel.entity.CProphecyType;

@Component
public class ProphecyTypeSysCache extends BaseExcelCache<CProphecyType> {

    private Map<Integer, Map<Integer, List<CProphecyType>>> prophecyTypeMap;

    @Override
    public String getFileName() {
        return "prophecytype";
    }

    @Override
    protected void loadAfterReady() {
    	Map<Integer, List<CProphecyType>> typeMap = this.fillListMap(CProphecyType::getType);
    	Map<Integer, Map<Integer, List<CProphecyType>>> tempProphecyTypeMap = new HashMap<>();
    	for(Entry<Integer, List<CProphecyType>> entry : typeMap.entrySet()) {
    		Map<Integer, List<CProphecyType>> elementMap = ListMapUtil.fillListMap(entry.getValue(), CProphecyType::getProphecy_type);
    		tempProphecyTypeMap.put(entry.getKey(), elementMap);
    	}
        this.prophecyTypeMap = tempProphecyTypeMap;
    }

    public List<CProphecyType> getProphecyTypeList(int type, int prophecyType) {
    	Map<Integer, List<CProphecyType>> elementMap = prophecyTypeMap.get(type);
		ConfigAsserts.notNull(elementMap, () -> String.format("CProphecyExchange is null type:%s", type));
		List<CProphecyType> result = elementMap.get(prophecyType);
		ConfigAsserts.notNull(result, () -> String.format("CProphecyExchange is null type:%s prophecyType:%s", type, prophecyType));
        return result;
    }
    /**
     * 普通抽奖
     */
    public static final int NORMAL = 1;
    /**
     * 幸运值抽奖
     */
    public static final int LUCKY = 2;
    /**
     * 首次抽奖
     */
    public static final int FIRST = 3;
}