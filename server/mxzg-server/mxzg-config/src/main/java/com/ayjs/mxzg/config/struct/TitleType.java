/**
 * 
 */
package com.ayjs.mxzg.config.struct;

/**
 * @author YY
 * 称号类型
 */
public enum TitleType {
	CHAMPION(1, "冠军赛"),
	LADDER(2, "天梯"),
	TEAM_ARENA(3, "组队竞技场"),
	SUPER_STAGE(4, "超凡段位赛"),
	PINNACLE(5, "巅峰赛"),
	MAGIC_TOWER(6, "幻魔塔"),
	;
	
	private final int value;
	private final String remark;
	
	private TitleType(int value, String remark) {
		this.value = value;
		this.remark = remark;
	}
	public int getValue() {
		return value;
	}
	public String getRemark() {
		return remark;
	}
}
