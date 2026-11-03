/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.task.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "mid_autumn_info", comment = "玩家中秋表")
public class MidAutumnInfo extends AbstractEntity {
	@Id
	@Column(name = "rid")
	private long rid;
	@Column(name = "num")
	private int num;
	public long getRid() {
		return rid;
	}
	public void setRid(long rid) {
		this.rid = rid;
	}
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
}
