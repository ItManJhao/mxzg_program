/*
 * Welcome to use the TableGo Tools.
 * 
 * http://www.tablego.cn
 * 
 * http://vipbooks.iteye.com
 * http://blog.csdn.net/vipbooks
 * http://www.cnblogs.com/vipbooks
 * 
 * Author: bianj
 * Email: tablego@qq.com
 * Version: 6.4.0
 */
package com.ayjs.mxzg.gameserver.module.fetter.domain;

import java.util.List;
import java.util.Set;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;

import lombok.Getter;
import lombok.Setter;


@Entity
@Table(name = "fetter_task_reward", comment = "羁绊任务奖励领取表")
@Getter
@Setter
public class FetterTaskReward extends AbstractEntity {

	@Id
	@Column(name = "rid", readOnly = true)
	private long rid;

	@Column(name = "task_id", comment = "任务ID")
	private List<Integer> taskId;
	
	@Column(name = "contracts", comment = "已经激活的契约")
	private Set<Integer> contracts;

	@Column(name = "goddess_reset",comment = "羁绊重置")
	private int goddessReset;

}