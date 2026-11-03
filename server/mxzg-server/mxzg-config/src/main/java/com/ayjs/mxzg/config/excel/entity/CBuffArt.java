package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.SourceType;
import lombok.Getter;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 英雄技能
 * 
 */
@Getter
public class CBuffArt implements BaseExcelModel {
	
	private int idx;
	
	public List<Integer> target;
	private int target_num;
	private SourceType source_type;		// 0buff施加者 1buff携带者
	public List<Integer> buff_list;
	public List<CBuff> buffs;
	public List<Integer> target_value;


	public List<Integer> getTarget() {
		return target;
	}

	public void setTarget(List<Integer> target) {
		this.target = target;
	}

	public List<Integer> getBuff_list() {
		return buff_list;
	}

	public void setBuff_list(List<Integer> buff_list) {
		this.buff_list = buff_list;
	}

	@Override
	public int getExcelId() {
		return idx;
	}
	
	/**
	 * 是否是最后一次目标选择，如果是则需要使用targetNum限制目标返回个数
	 * @param typeValue
	 * @return
	 */
	public boolean isLastType(int typeValue){
		int lastIndex = this.target.size() - 1;
		return this.target.get(lastIndex) == typeValue;
	}

	/**
	 * 排序把动作前置
	 * @param buffs
	 */
	public void setBuffs(List<CBuff> buffs) {
		List<CBuff> actionBuffs = buffs.stream().filter(buff-> !buff.getType().isLogic()).collect(Collectors.toList());
		buffs.removeAll(actionBuffs);
		actionBuffs.addAll(buffs);
		this.buffs = actionBuffs;
	}

}