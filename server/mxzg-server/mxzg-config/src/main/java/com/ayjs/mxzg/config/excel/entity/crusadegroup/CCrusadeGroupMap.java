package com.ayjs.mxzg.config.excel.entity.crusadegroup;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * 讨伐团地图表
 */
@Getter
public class CCrusadeGroupMap implements BaseExcelModel {

    /**
     * 主键
     */
    private int idx;
    /**
     * 地图id
     */
    private int group_id;
    /**
     * x坐标
     */
    private int x;
    /**
     * y坐标
     */
    private int y;
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
    private TerritoryType fight_type;


    @Override
    public int getExcelId(){ return idx;
    }

    /**
     * 当前地图格子是否在指定的坐标范围
     *
     * @param bottomLeftX
     * @param bottomLeftY
     * @param upperRightX
     * @param upperRightY
     * @return
     */
    public boolean isInRange(int bottomLeftX, int bottomLeftY, int upperRightX, int upperRightY) {
        return this.x >= bottomLeftX && this.x <= upperRightX && this.y >= bottomLeftY && this.y <= upperRightY;
    }
}
