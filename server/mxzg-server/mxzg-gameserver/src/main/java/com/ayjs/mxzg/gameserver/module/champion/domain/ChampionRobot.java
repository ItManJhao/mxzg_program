/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.champion.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "champion_robot", comment = "冠军赛机器人信息", indexes = {
		@Index(name = "rbid", columnList = { "rbid" }) }, cache = { @Cache(columns = "rbid") })
public class ChampionRobot extends AbstractEntity {
	@Id
	@Column(name = "id", comment = "唯一ID")
	@LongIdGenerate
	private long id;
	@Column(name = "rbid", comment = "机器人ID", readOnly = true)
	private long rbid;
	@Column(name = "like", comment = "历史收获点赞次数")
	private int like;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public int getLike() {
		return like;
	}

	public void setLike(int like) {
		this.like = like;
	}

	public long getRbid() {
		return rbid;
	}

	public void setRbid(long rbid) {
		this.rbid = rbid;
	}
}
