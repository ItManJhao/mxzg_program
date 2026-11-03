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
import com.ayjs.mxzg.common.persistence.annotation.Cache;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Index;
import com.ayjs.mxzg.common.persistence.annotation.LongIdGenerate;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.util.HashSet;
import java.util.Set;

/**
 * FetterGoddess
 */
@Entity
@Table(name = "fetter_goddess2", comment = "女神")
@Getter
@Setter
public class FetterGoddess2 extends AbstractEntity {

    @Id
    @Column(name = "rid", unique = true, comment = "角色ID", readOnly = true)
    private long rid;

    @Column(name = "level", comment = "神器等级")
    private int level;

    @Column(name = "exp", comment = "神器经验值")
    private int exp;

    @Column(name = "skill_level", comment = "技能等级")
    private int skillLevel;

    @Column(name = "refine_level", comment = "精炼等级")
    private int refineLevel;

    @Column(name = "uplimit_level", comment = "突破等级")
    private int uplimitLevel;

    @Column(name = "soul_level", comment = "铸魂次数")
    private int soulLevel;

    @Column(name = "wash_level",comment = "洗炼等级")
    private int washLevel;

    @Column(name = "active_type", comment = "已解锁类型")
    private Set<Integer> activeType = new HashSet<>();

}