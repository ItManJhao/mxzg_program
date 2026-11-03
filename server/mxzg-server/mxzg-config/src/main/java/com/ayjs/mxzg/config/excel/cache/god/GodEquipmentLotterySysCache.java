/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache.god;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.god.CGodEquipmentLottery;

/**
 * @author YY
 *
 */
@Component
public class GodEquipmentLotterySysCache extends BaseExcelCache<CGodEquipmentLottery> {

	private Map<Integer, List<CGodEquipmentLottery>> normalStarMap;

	private Map<Integer, List<CGodEquipmentLottery>> specialStarMap;

	private List<CGodEquipmentLottery> allGuaranteeList;//保底出奖池

	private List<CGodEquipmentLottery> allSpecialList;//需要记录次数的特殊奖池

	@Override
	public String getFileName() {
		return "godequipmentlottery";
	}

	@Override
	protected void loadAfterReady() {
		Map<Integer, List<CGodEquipmentLottery>> tempNormalStarMap = new HashMap<>();
		Map<Integer, List<CGodEquipmentLottery>> tempSpecialStarMap = new HashMap<>();
		List<CGodEquipmentLottery> tempAllGuaranteeList = new ArrayList<>();
		List<CGodEquipmentLottery> tempAllSpecialList = new ArrayList<>();

		for(CGodEquipmentLottery config : this.getAll()) {
			List<CGodEquipmentLottery> normalList = tempNormalStarMap.get(config.getReward_type());
			if(normalList == null) {
				normalList = new ArrayList<>();
				tempNormalStarMap.put(config.getReward_type(), normalList);
			}
			List<CGodEquipmentLottery> specialList = tempSpecialStarMap.get(config.getReward_type());
			if(specialList == null) {
				specialList = new ArrayList<>();
				tempSpecialStarMap.put(config.getReward_type(), specialList);
			}
			if(config.getShow_min() <= 0 && config.getShow_max() <= 0) {
				//普通的任务
				normalList.add(config);
			} else {
				//特殊的任务
				specialList.add(config);
				tempAllSpecialList.add(config);
			}
			if(config.getGuarantee() == 1){
				tempAllGuaranteeList.add(config);
			}
		}
		this.normalStarMap = tempNormalStarMap;
		this.specialStarMap = tempSpecialStarMap;
		this.allGuaranteeList = tempAllGuaranteeList;
		this.allSpecialList = tempAllSpecialList;
	}

	public List<CGodEquipmentLottery> getNormalList(int star) {
		return normalStarMap.get(star);
	}

	public List<CGodEquipmentLottery> getSpecialList(int star) {
		return specialStarMap.get(star);
	}

	public List<CGodEquipmentLottery> getAllGuaranteeList() {
		return allGuaranteeList;
	}

	public List<CGodEquipmentLottery> getAllSpecialList() {
		return allSpecialList;
	}


}
