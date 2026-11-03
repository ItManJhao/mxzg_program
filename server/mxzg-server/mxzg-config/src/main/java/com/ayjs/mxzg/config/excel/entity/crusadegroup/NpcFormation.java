package com.ayjs.mxzg.config.excel.entity.crusadegroup;

import lombok.Value;

import java.util.List;

@Value(staticConstructor = "of")
public class NpcFormation {
    private int teamId; //队伍id
    private List<CCrusadeGroupNpc> formation;

    /**
     * 获取领地等级
     * @return
     */
    public int getAreaLevel(){
        return this.formation.get(0).getArea_level();
    }

    /**
     * 获取领地类型
     * @return
     */
    public int getBuildingLevel(){
        return this.formation.get(0).getBuilding_level();
    }

    /**
     * 获取领地的npc类型
     * @return
     */
    public TerritoryType getType(){
        return this.formation.get(0).getType();
    }

    /**
     * 是否是boss
     * @return
     */
    public boolean isBoss(){
        return this.formation.get(0).isBoss();
    }

    /**
     * 是否是空地
     * @return
     */
    public boolean isSpace() {
        return this.formation.get(0).getType() == TerritoryType.ORDINARY;
    }

    /**
     * 是否是最终boss
     * @return
     */
    public boolean isFinalBoss(){
        return isBoss() && this.formation.get(0).getType() == TerritoryType.BOSS;
    }
}
