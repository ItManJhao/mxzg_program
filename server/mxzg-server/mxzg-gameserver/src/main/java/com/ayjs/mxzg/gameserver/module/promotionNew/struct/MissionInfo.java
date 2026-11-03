package com.ayjs.mxzg.gameserver.module.promotionNew.struct;

import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/8/6
 **/
@Getter
@Setter
public class MissionInfo {

    /***
     * 配置表id
     */
    private int idx;

    /***
     * 进度值
     */
    private long process;

    /***
     * 是否已经领奖
     */
    private boolean hadReward;

    public static MissionInfo valueOf(int idx) {
        MissionInfo missionInfo = new MissionInfo();
        missionInfo.idx = idx;
        return missionInfo;
    }
}
