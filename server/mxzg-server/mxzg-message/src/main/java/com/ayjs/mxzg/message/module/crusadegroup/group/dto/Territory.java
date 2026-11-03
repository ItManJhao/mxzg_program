package com.ayjs.mxzg.message.module.crusadegroup.group.dto;

import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * 领地信息
 */
@Data(staticConstructor = "valueOf")
@AllArgsConstructor
public class Territory {

    /** 领地id */
    private int id;
    /** 占领者Id */
    private long occupierId;
    /** 元素id */
    private int elementId;
    /** 驻守的英雄主键id */
    private long heroId;
    /** 神兵精华的结算时间 */
    private int essenceSettlementTime;
    /** 神兵精华的结算时间 */
    private int shenbinSettlementTime;

    public static Territory valueOf(int id, long occupierId, int elementId, long heroId){
        return new Territory(id, occupierId, elementId, heroId, TimeDateUtil.getCurrentTimeInt(), TimeDateUtil.getCurrentTimeInt());
    }

    /**
     * 取消开发
     */
    public void cancelDevelopment(){
        this.heroId = 0;
    }

    /**
     * 开发领地
     * @param heroId
     */
    public void development(long heroId){
        this.heroId = heroId;
    }

    /**
     * 是否是開發中
     * @return
     */
    public boolean isDevelopment(){
        return this.heroId != 0;
    }

    /**
     * 修改精华结算时间
     * @param time
     */
    public void updateEssenceSettlementTime(int time){
        this.essenceSettlementTime += time;
    }

    /**
     * 修改神兵结算时间
     * @param time
     */
    public void updateShenBinSettlementTime(int time){
        this.shenbinSettlementTime += time;
    }
}
