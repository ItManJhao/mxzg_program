/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.title.domain;

import java.util.concurrent.ConcurrentMap;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.title.struct.TitleData;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "title", comment = "称号")
public class Title extends AbstractEntity {
	@Id
	@Column(name = "rid", comment = "玩家ID")
	private long rid;
	@Column(name = "titles", comment = "称号数据")
	private ConcurrentMap<Integer, TitleData> titles;
	public long getRid() {
		return rid;
	}
	public void setRid(long rid) {
		this.rid = rid;
	}
	public ConcurrentMap<Integer, TitleData> getTitles() {
		return titles;
	}
	public void setTitles(ConcurrentMap<Integer, TitleData> titles) {
		this.titles = titles;
	}
}
