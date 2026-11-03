package com.ayjs.mxzg.gameserver.module.promotionNew.struct;

import lombok.Data;

/**
 * @Author: CWJ
 * @Date: 2019/12/2
 **/
@Data
public class ZhuShenLevelInfo {

    /**
     * 当前关卡
     */
    private int level;
    /**
     * 总血量
     */
    private long totalHp;
    /**
     * 当前血量比
     */
    private int currHpRate;

}
