package com.ayjs.mxzg.config.excel.entity.crusadegroup;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import lombok.Getter;

import java.util.List;

/**
 * 讨伐团地图表
 */
@Getter
public class CCrusadeGroupBuild implements BaseExcelModel {

    /**
     * 主键
     */
    private int id;
    /**
     * 地皮等级
     */
    private int area_level;
    /**
     * 建筑等级
     */
    private int building_level;
    /**
     * 领地所属类型
     */
    private TerritoryType type;
    /**
     * 产量
     */
    private int cream_output;
    /**
     * 装备掉落库
     */
    private int shenbing_drop;
    /**
     * 神兵产出cd
     */
    private int shenbing_cd;
    /**
     * 是否可以被占领
     */
    private boolean seize_is;
    /**
     * 是否可以驻守
     */
    private boolean defend_is;
    /**
     * 驻守的星级
     */
    private int defend_star;
    /**
     * 怪物的波数
     */
    private int mon_team;
    /**
     * 奖励
     */
    private List<ImmutableThing> reward;
    /**
     * 消耗的体力
     */
    private int cost_energy;
    /**
     * 建筑名(多语言)
     */
    private String name;
    /**
     * 战斗类型
     */
    private int battletype;

    @Override
    public int getExcelId(){ return id;
    }

    /**
     * 是否是空地
     *
     * @return
     */
    public boolean isSpace() {
        return this.type == TerritoryType.ORDINARY;
    }
}
