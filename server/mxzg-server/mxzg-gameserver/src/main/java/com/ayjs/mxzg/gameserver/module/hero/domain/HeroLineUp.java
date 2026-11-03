/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.domain;

import java.util.Map;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroPosition;

import lombok.Getter;
import lombok.Setter;

/**
 * @author YY 英雄布阵
 */
@Entity
@Table(name = "hero_line_up", comment = "英雄布阵表", indexes = { @Index(name = "rid", columnList = { "rid" }) }, cache = {
		@Cache(columns = "rid") })
@Getter
@Setter
public class HeroLineUp extends AbstractEntity {
	@Id
	@LongIdGenerate
	@Column(name = "id")
	private long id;
	@Column(name = "rid", readOnly = true)
	private long rid;
	@Column(name = "type", comment = "队伍类型")
	private int type;
	@Column(name = "formation", comment = "阵型信息", length = 500)
	private Map<Long, HeroPosition> formationMap;
	@Column(name = "goddess_type", comment = "神器类型")
	private int goddessType;
	@Column(name = "time", comment = "队伍保存时间")
	private int time;
	@Column(name = "formation_id", comment = "阵法id")
	private int formationId;
}
