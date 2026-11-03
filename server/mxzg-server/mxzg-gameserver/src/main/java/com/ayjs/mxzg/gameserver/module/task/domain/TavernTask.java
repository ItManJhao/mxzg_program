/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.task.domain;

import java.util.ArrayList;
import java.util.List;

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
@Table(name = "tavern_task", comment = "酒馆任务", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
public class TavernTask extends AbstractEntity {
	@Id
	@LongIdGenerate
	@Column(name = "id")
	private long id;
	@Column(name = "rid", comment = "角色ID", readOnly = true)
	private long rid;
	@Column(name = "type", comment = "酒馆任务类型(对应配置表idx)")
	private int type;
	@Column(name = "status", comment = "状态值：0：未派遣:，1：进行中")
	private int status;
	@Column(name = "start_time", comment = "任务开始时间")
	private int startTime;
	@Column(name = "heros", comment = "状态值：0：未派遣:，1：进行中", length = 100)
	private List<Long> heros = new ArrayList<>();
	@Column(name = "task_lock",comment = "1已上锁，0未上锁")
	private int taskLock = 0;
	
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public long getRid() {
		return rid;
	}
	public void setRid(long rid) {
		this.rid = rid;
	}
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public int getStartTime() {
		return startTime;
	}
	public void setStartTime(int startTime) {
		this.startTime = startTime;
	}
	public List<Long> getHeros() {
		return heros;
	}
	public void setHeros(List<Long> heros) {
		this.heros = heros;
	}

	public int getTaskLock() {
		return taskLock;
	}

	public void setTaskLock(int taskLock) {
		this.taskLock = taskLock;
	}
}
