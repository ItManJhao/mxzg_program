package com.ayjs.mxzg.gameserver.module.dungeon.domain;

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
 * dungeon_backpack
 *
 */
@Entity
@Table(name = "dungeon_backpack" , comment = "地牢道具背包", indexes = {@Index( name = "rid" , columnList = {"rid"})},
		cache = {@Cache( columns = "rid")})
@Getter
@Setter
public class DungeonBackpack extends AbstractEntity {
	@Id
	@Column(name = "id")
	@LongIdGenerate
	private long id;
	@Column(name = "rid" , readOnly = true)
	private long rid;
	@Column(name = "item_id", comment = "道具ID")
	private int itemId;
	@Column(name = "num", comment = "道具数量")
	private int num;
	@Column(name = "use_num", comment = "已使用的道具数量")
	private int useNum;
}
