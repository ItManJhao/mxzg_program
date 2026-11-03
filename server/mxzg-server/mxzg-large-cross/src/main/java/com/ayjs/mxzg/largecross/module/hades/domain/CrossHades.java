package com.ayjs.mxzg.largecross.module.hades.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2021/1/5
 **/
@Setter
@Getter
@Entity
@Table(name = "cross_hades", comment = "冥域魔都")
public class CrossHades extends AbstractEntity {
    @Id
    @Column(name = "rid", comment = "角色id")
    private long rid;
    @Column(name = "pass_floor", comment = "通关层数")
    private Map<Integer, Integer> passFloor = new HashMap<>();
    @Column(name = "rank_time", comment = "排行榜时间")
    private Map<Integer, Integer> rankTime = new HashMap<>();
    @Column(name = "fighting", comment = "通关战力")
    private int fighting;

    public int getFloorByType(int type) {
        return passFloor.getOrDefault(type, 0);
    }

    public void updateFloor(int type, int floor) {
        passFloor.put(type, floor);
        rankTime.put(type, TimeDateUtil.getCurrentTimeInt());
    }

    public int getRankTimeByType(int type) {
        return rankTime.getOrDefault(type, 0);
    }

}
