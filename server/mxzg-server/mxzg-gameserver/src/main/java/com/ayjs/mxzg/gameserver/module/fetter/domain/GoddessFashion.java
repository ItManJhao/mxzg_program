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


import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.HashSet;
import java.util.Set;

/**
 * FetterGoddess
 */
@Entity
@Table(name = "goddess_fashion", comment = "女神皮肤")
@Getter
@Setter
public class GoddessFashion extends AbstractEntity {
    @Id
    @Column(name = "rid", comment = "角色ID")
    private long rid;
    @Column(name = "active_type", comment = "已解锁类型")
    private Set<Integer> activeType = new HashSet<>();
    @Column(name = "task_reward", comment = "任务领取记录")
    private Set<Integer> task_reward = new HashSet<>();
    @Column(name = "curr_use", comment = "当前使用的皮肤")
    private int currUse;

}