/**
 * 
 */
package com.ayjs.mxzg.largecross.module.towercross.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;

import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "tower_cross_role", comment = "跨服爬塔个人信息")
@Getter
@Setter
public class TowerCrossRole extends AbstractEntity {
	@Id
    @Column(name = "rid", comment = "玩家ID")
	private long rid;
	@Column(name = "curr_layer", comment = "当前已通关最高层数")
	private int currLayer;
	@Column(name = "time", comment = "通关时间")
	private int time;
	@Column(name = "his_fighting", comment = "历史最高战力")
	private int hisFighting;
}
