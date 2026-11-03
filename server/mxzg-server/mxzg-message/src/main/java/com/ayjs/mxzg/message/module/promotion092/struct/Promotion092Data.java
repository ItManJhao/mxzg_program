package com.ayjs.mxzg.message.module.promotion092.struct;

import com.ayjs.mxzg.message.module.teamArena.domain.RoleSimpleMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2021/1/6
 **/
@Getter
@Setter
public class Promotion092Data {

    private long rankId;

    /***
     * 玩家信息
     */
    private RoleSimpleMessage roleSimpleMessage;

    private int rank;

    private int rankValue;

    private int rankTime;

}
