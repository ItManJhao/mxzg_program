/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.clanworldboss.domain;

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
@Table(name = "clanworldboss_report", comment = "公会世界BOSS发奖信息", indexes = {
		@Index(name = "round", columnList = { "round" }) }, cache = { @Cache(columns = "round") })
@Getter
@Setter
public class ClanWorldBossReport extends AbstractEntity {
	@Id
	@LongIdGenerate
	@Column(name = "id", comment = "唯一ID")
	private long id;
	@Column(name = "round", comment = "轮数", readOnly = true)
	private int round;
	@Column(name = "status", comment = "发奖状态，0未发奖，1已发奖")
	private int state;
	@Column(name = "server_id",comment = "服务器id")
	private int serverId;
	@Column(name = "insert_time",comment = "插入时间")
	private int insertTime;



}
