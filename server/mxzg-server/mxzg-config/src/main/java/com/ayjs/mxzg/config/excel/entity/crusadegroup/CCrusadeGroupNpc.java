package com.ayjs.mxzg.config.excel.entity.crusadegroup;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeKind;
import com.ayjs.mxzg.config.struct.EquipInfo;
import com.ayjs.mxzg.config.struct.HeroConfig;
import com.ayjs.mxzg.config.struct.RunesVo;
import lombok.Getter;

import java.util.List;

/**
 * 讨伐团周期表
 */
@Getter
public class CCrusadeGroupNpc implements HeroConfig, BaseExcelModel {

    /**
     * 主键
     */
    private int idx;
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
     * 是否是boss
     */
    private boolean boss;

    /**
     * 队伍编号
     */
    private int team;
    /**
     * 位置
     */
    private int pos;
    /**
     * 英雄类型
     */
    private int hero_type;
    /**
     * 英雄等级
     */
    private int hero_level;
    /**
     * 英雄等级
     */
    private int hero_star;
    /**
     * 属性
     */
    private List<AttributeKind> attr;

    /**
     * 神兵等级
     */
    private int shenbing;

    @Override
    public int getExcelId(){ return idx;
    }

    @Override
    public List<EquipInfo> getEquipment() {
        return null;
    }

    @Override
    public List<RunesVo> getRunes() {
        return null;
    }
}
