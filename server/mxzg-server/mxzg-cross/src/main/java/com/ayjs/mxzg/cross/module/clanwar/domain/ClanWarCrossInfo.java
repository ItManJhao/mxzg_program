/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanwar.domain;

import java.util.Set;

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
@Table(name = "clanwar_cross_info", comment = "公会战在跨服上的数据")
public class ClanWarCrossInfo extends AbstractEntity {
	@Id
	@Column(name = "clan_id", comment = "公会ID")
	private long clanId;
	@Column(name = "rival_clan_ids", comment = "公会战最近匹配过的公会")
	private Set<Long> rivalClanIds;
	public long getClanId() {
		return clanId;
	}
	public void setClanId(long clanId) {
		this.clanId = clanId;
	}
	public Set<Long> getRivalClanIds() {
		return rivalClanIds;
	}
	public void setRivalClanIds(Set<Long> rivalClanIds) {
		this.rivalClanIds = rivalClanIds;
	}
}
