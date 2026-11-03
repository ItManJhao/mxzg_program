/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.godequip.domain;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.godequip.struct.GodEquipRecord;

import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 *
 */
@Entity
@Table(name = "god_equip_sys_info", comment = "神装服务器信息表")
@Getter
@Setter
public class GodEquipSysInfo extends AbstractEntity {
	@Id
    @LongIdGenerate
    @Column(name = "id", comment = "主键id")
	private long id;
	@Column(name = "records", comment = "神装抽奖记录")
	private CopyOnWriteArrayList<GodEquipRecord> records = new CopyOnWriteArrayList<>();
}
