/**
 * 
 */
package com.ayjs.mxzg.largecross.module.towercross.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;

import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "tower_cross_system", comment = "跨服爬塔系统信息")
@Getter
@Setter
public class TowerCrossSystem extends AbstractEntity {
	@Id
    @Column(name = "id", comment = "唯一ID")
    @LongIdGenerate
	private long id;
	@Column(name = "round", comment = "本届活动轮数")
	private int round;
	@Column(name = "start_time", comment = "本届开始时间")
	private int startTime;
	@Column(name = "end_time", comment = "本届结算时间")
	private int endTime;
	@Column(name = "next_time", comment = "下一届开始时间")
	private int nextTime;
	@Column(name = "state", comment = "结算状态")
	private int state;
}
