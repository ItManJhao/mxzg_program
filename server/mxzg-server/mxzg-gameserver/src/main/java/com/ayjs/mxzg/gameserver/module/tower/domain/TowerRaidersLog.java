/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.tower.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.util.StringUtil;


@Entity
@Table(name = "tower_raiders_log", comment = "幻境之塔通关攻略日志")
public class TowerRaidersLog extends AbstractEntity {
	@Id
	@Column(name = "stage", comment = "关卡")
	private int stage;
	@Column(name = "fastest",comment = "最快通关")
	private TowerRaiders fastest;
	@Column(name = "lowest", comment = "最低战力通关")
	private TowerRaiders lowest;

	public int getStage() {
		return stage;
	}

	public void setStage(int stage) {
		this.stage = stage;
	}

	public TowerRaiders getFastest() {
		return fastest;
	}

	public void setFastest(TowerRaiders fastest) {
		this.fastest = fastest;
	}

	public TowerRaiders getLowest() {
		return lowest;
	}

	public void setLowest(TowerRaiders lowest) {
		this.lowest = lowest;
	}

	public boolean fastestIsEmpty(){
	    return this.fastest == null || StringUtil.isBlank(this.fastest.getBattleId());
    }

    public boolean lowestIsEmpty(){
        return this.lowest == null || StringUtil.isBlank(this.lowest.getBattleId());
    }
}
