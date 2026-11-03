package com.ayjs.mxzg.gameserver.module.battle.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;


@Entity
@Table(name = "formation", comment = "英雄阵法表")
@Getter
@Setter
public class Formation extends AbstractEntity {

    @Id
    @Column(name = "rid", comment = "玩家id")
    private long rid;

    @Column(name = "unlock",comment = "是否解锁了第二契约")
    private boolean unlock;

    @Column(name = "unlock_formation_ids",comment = "解锁的阵型id列表")
    private List<Integer> unlockFormationIds = new ArrayList<>();

    /**
     * 解锁阵法
     * @param formationId
     */
    public void unlock(int formationId){
        this.unlockFormationIds.add(formationId);
    }

    /**
     * 是否解锁了指定的阵法
     * @param formationId
     * @return
     */
    public boolean isUnlock(int formationId){
        return formationId == 0 || this.unlockFormationIds.contains(formationId);
    }

}

