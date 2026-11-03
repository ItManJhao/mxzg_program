/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.pvp.domain;

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
@Table(name = "pvp_sys_info", comment = "系统的竞技场信息表")
@Getter
@Setter
public class PvpSysInfo extends AbstractEntity {
	@Id
    @LongIdGenerate
    @Column(name = "id", comment = "主键id")
	private long id;
	@Column(name = "daily_time", comment = "每日重置时间")
	private int dailyTime;
	@Column(name = "season_time", comment = "每季重置时间")
	private int seasonTime;
}
