/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.towercross.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;

import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "tower_cross_result", comment = "跨服爬塔历届结算信息", indexes = {
		@Index(name = "round", columnList = { "round" }) }, cache = { @Cache(columns = { "round" }) })
@Getter
@Setter
public class TowerCrossResult extends AbstractEntity {
	@Id
    @Column(name = "id", comment = "唯一ID")
    @LongIdGenerate
	private long id;
	@Column(name = "round", comment = "本届活动轮数", readOnly = true)
	private int round;
	@Column(name = "result", comment = "结算状态")
	private int result;
}
