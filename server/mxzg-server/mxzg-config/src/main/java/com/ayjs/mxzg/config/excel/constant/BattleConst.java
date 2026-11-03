package com.ayjs.mxzg.config.excel.constant;

import com.alibaba.fastjson.JSON;
import com.ayjs.mxzg.common.excel.ExcelDictionaryCache;
import com.ayjs.mxzg.config.struct.ContractCondition;
import lombok.Getter;
import org.springframework.stereotype.Component;

import java.util.Map;

@Getter
@Component
public class BattleConst extends ExcelDictionaryCache {
	

	/** 第二契约解锁条件 */
	private ContractCondition condition;


	@Override
	public void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
		String strCondition = map.get("contract_2_mission").getValue();
		this.condition = JSON.parseObject(strCondition, ContractCondition.class);
	}

}
