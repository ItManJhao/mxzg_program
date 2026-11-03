/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;


@Entity
@Table(name = "pinnacle_report", comment = "巅峰赛发奖信息")
@Getter
@Setter
public class PinnacleReport extends AbstractEntity {
	@Id
	@Column(name = "id", comment = "唯一ID")
	private int id;
	@Column(name = "status", comment = "发奖状态，0未发奖，1已发奖")
	private int state;

	/**
	 * 重置状态
	 */
	public void reset(){
		this.state = 0;
	}
}
