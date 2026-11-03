package com.ayjs.mxzg.gameserver.module.magicTower.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.HashSet;
import java.util.Set;

@Table(name = "magic_tower_road", comment = "魔幻塔斩魔之路")
@Getter
@Setter
@Entity
public class MagicTowerRoad extends AbstractEntity {
    @Id
    @Column(name = "rid", comment = "玩家id")
    private long rid;

    @Column(name = "normal_set", comment = "斩魔之路奖励")
    private Set<Integer> normalSet = new HashSet<>();

    @Column(name = "king_set", comment = "斩魔王者奖励")
    private Set<Integer> kingSet = new HashSet<>();

    @Column(name = "king_state", comment = "斩魔王者解锁状态 0/1")
    private int kingState;

    @Column(name = "buy_time", comment = "斩魔王者解锁时间")
    private long buyTime;
}
