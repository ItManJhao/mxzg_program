package com.ayjs.mxzg.cross.module.crusadegroup.map.domain;


import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import lombok.Getter;
import lombok.Setter;

import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "cross_crusaders", comment = "跨服讨伐者")
@Getter
@Setter
public class CrossCrusaders extends AbstractEntity {

    @Id
    @Column(name = "rid", comment = "角色id")
    private long rid;

    @Column(name = "birthplace_id", comment = "出生点领地id")
    private int birthplace_id;

    @Column(name = "last_occupied_id", comment = "最后占领的领地id")
    private int lastOccupiedId;

    @Column(name = "occupied_ids", comment = "占领的领地id列表")
    private Set<Integer> occupiedIds = new HashSet<>();

    @Column(name = "knighthood_id", comment = "爵位id")
    private int knighthoodId;

    @Column(name = "shenBin", comment = "精华数量")
    private long shenBin;

    @Column(name = "shenBin_update_time", comment = "神兵精华数量修改时间")
    private int shenBinUpdateTime;

    @Column(name = "bossHurt", comment = "boss伤害")
    private long bossHurt;

    @Column(name = "bossHurt_update_time", comment = "boss伤害修改时间")
    private int bossHurtUpdateTime;

    @Column(name = "fighting", comment = "战力")
    private int fighting;


    /**
     * 设置出生点
     * @param birthplaceId
     */
    public void setBirthplace(int birthplaceId){
        this.birthplace_id = birthplaceId;
        this.lastOccupiedId = birthplaceId;
        this.occupiedIds.add(birthplaceId);
    }

    /**
     * 更新boss伤害
     * @param damage
     */
    public void updateBossHurt(long damage){
        this.bossHurt += damage;
        this.bossHurtUpdateTime = DateTimeUtil.currentSecond();
    }

    /**
     * 更新神兵精华
     *
     * @param addNum
     */
    public void updateShenBin(long addNum) {
        this.shenBin += addNum;
        this.shenBinUpdateTime = DateTimeUtil.currentSecond();
    }

}
