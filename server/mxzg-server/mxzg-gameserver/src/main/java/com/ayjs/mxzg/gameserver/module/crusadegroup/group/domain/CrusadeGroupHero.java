package com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain;

import lombok.Getter;
import lombok.Setter;

/**
 * 讨伐团英雄信息
 */
@Getter
@Setter
public class CrusadeGroupHero {

    private int id;     //boxId，所在的背包的id

    private long heroId;    //英雄id

    private int physicalStrength;   //体力值

    private int developmentTerritoryId; //开发的领地id

    public static CrusadeGroupHero createOfBox(int boxId, int physicalStrength){
        CrusadeGroupHero hero = new CrusadeGroupHero();
        hero.setId(boxId);
        hero.setPhysicalStrength(physicalStrength);
        return hero;
    }

    /**
     * 清空英雄上阵信息
     */
    public void clean(boolean cleanPhysicalStrength) {
        this.heroId = 0;
        this.developmentTerritoryId = 0;
        if (cleanPhysicalStrength) {
            this.physicalStrength = 0;
        }
    }

    /**
     * 放弃开发
     */
    public void giveUpDevelopment(){
        this.developmentTerritoryId = 0;
    }

    /**
     * 消耗体力
     * @param energy
     */
    public void costEnergy(int energy){
        this.physicalStrength -= energy;
    }

    /**
     * 不为空
     * @return
     */
    public boolean notEmpty(){
        return this.heroId != 0;
    }

    /**
     * 恢复体力
     * @param physicalStrength
     */
    public void recoveryPhysical(int physicalStrength){
        this.physicalStrength += physicalStrength;
    }

}
