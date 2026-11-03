package com.ayjs.mxzg.gameserver.module.hades.domain;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.common.persistence.annotation.Column;
import com.ayjs.mxzg.common.persistence.annotation.Entity;
import com.ayjs.mxzg.common.persistence.annotation.Id;
import com.ayjs.mxzg.common.persistence.annotation.Table;
import com.ayjs.mxzg.gameserver.module.hades.constant.HadesInfo;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2021/1/5
 **/
@Setter
@Getter
@Entity
@Table(name = "hades", comment = "冥域魔都")
public class Hades extends AbstractEntity {
    @Id
    @Column(name = "rid", comment = "角色id")
    private long rid;
    @Column(name = "hades_info_map", comment = "副本信息")
    private Map<Integer, HadesInfo> hadesInfoMap = new HashMap<>();
    @Column(name = "count_refresh", comment = "次数刷新时间")
    private LocalDate countRefresh = LocalDate.of(2021, 1, 5);
    @Column(name = "sweep_count", comment = "扫荡次数")
    private int sweepCount;

    public int getFloorByType(int type) {
        HadesInfo hadesInfo = hadesInfoMap.get(type);
        return hadesInfo == null ? 0 : hadesInfo.getPassFloor();
    }

    public int getSweepCount(int type) {
        return sweepCount;
    }

    public void putFloor(int type, int floor) {
        HadesInfo hadesInfo = hadesInfoMap.get(type);
        if (hadesInfo == null) {
            hadesInfo = new HadesInfo();
            hadesInfo.setType(type);
            hadesInfoMap.putIfAbsent(type, hadesInfo);
            hadesInfo = hadesInfoMap.get(type);
        }
        hadesInfo.setPassFloor(floor);
    }

    public void addSweep(int type, int addValue) {
        sweepCount += addValue;
    }

}
