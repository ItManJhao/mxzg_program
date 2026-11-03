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

/**
 * FetterGoddess
 */
@Entity
@Table(name = "fetter_goddess", indexes = {@Index(name = "rid", columnList = {"rid"})}, cache = {@Cache(columns = "rid")})
@Data
public class FetterGoddess extends AbstractEntity {

    @Id
    @Column(name = "id")
    @LongIdGenerate
    private long id;

    @Column(name = "rid", unique = true, comment = "角色ID", readOnly = true)
    private long rid;

    @Column(name = "goddess_type", unique = true, comment = "神器类型")
    private int goddessType;

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

    @Column(name = "soul_level", comment = "铸魂等级")
    private int soulLevel;

    public long getRid() {
        return this.rid;
    }


    public void setRid(long rid) {
        this.rid = rid;
    }


    public int getGoddessType() {
        return this.goddessType;
    }

    public void setGoddessType(int goddessType) {
        this.goddessType = goddessType;
    }


    public int getLevel() {
        return this.level;
    }


    public void setLevel(int level) {
        this.level = level;
    }

    public int getSoulLevel() {
        return soulLevel;
    }

    public void setSoulLevel(int soulLevel) {
        this.soulLevel = soulLevel;
    }

    public int getExp() {
        return this.exp;
    }


    public void setExp(int exp) {
        this.exp = exp;
    }


    public int getSkillLevel() {
        return this.skillLevel;
    }


    public void setSkillLevel(int skillLevel) {
        this.skillLevel = skillLevel;
    }


    public int getRefineLevel() {
        return this.refineLevel;
    }

    public void setRefineLevel(int refineLevel) {
        this.refineLevel = refineLevel;
    }


    public int getUplimitLevel() {
        return this.uplimitLevel;
    }

    public void setUplimitLevel(int uplimitLevel) {
        this.uplimitLevel = uplimitLevel;
    }

}