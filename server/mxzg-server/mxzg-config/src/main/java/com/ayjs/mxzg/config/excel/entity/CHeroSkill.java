package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ActiveType;
import lombok.Getter;

import java.util.List;

/**
 * 英雄技能
 * 
 */
@Getter
public class CHeroSkill implements BaseExcelModel {
	
	private int idx;
	public int type;
	public int level;
	private int initial_round;
	private int cool_round;
	public boolean count_stats;
	public ActiveType active_type;
	public List<Integer> art_list;
	public String file;
	public boolean first;	//先手技能
	private String note1;
	
	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public boolean getCount_stats() {
		return count_stats;
	}

	public void setCount_stats(boolean count_stats) {
		this.count_stats = count_stats;
	}

	public ActiveType getActive_type() {
		return active_type;
	}

	public void setActive_type(ActiveType active_type) {
		this.active_type = active_type;
	}

	public List<Integer> getArt_list() {
		return art_list;
	}

	public void setArt_list(List<Integer> art_list) {
		this.art_list = art_list;
	}

	public String getFile() {
		return file;
	}

	public void setFile(String file) {
		this.file = file;
	}

	public int getLevel() {
		return level;
	}

	public void setLevel(int level) {
		this.level = level;
	}

	public int getInitial_round() {
		return initial_round;
	}

	public void setInitial_round(int initial_round) {
		this.initial_round = initial_round;
	}

	public int getCool_round() {
		return cool_round;
	}

	public void setCool_round(int cool_round) {
		this.cool_round = cool_round;
	}

	public boolean isCount_stats() {
		return count_stats;
	}

	public int getIdx() {
		return idx;
	}

	public void setIdx(int idx) {
		this.idx = idx;
	}

	public boolean isFirst() {
		return first;
	}

	public void setFirst(boolean first) {
		this.first = first;
	}

	@Override
	public int getExcelId() {
		return idx;
	}

	@Override
	public String toString() {
		return note1 + " " + art_list;
	}
}