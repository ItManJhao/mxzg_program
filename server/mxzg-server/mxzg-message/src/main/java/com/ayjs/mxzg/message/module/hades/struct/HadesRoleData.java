package com.ayjs.mxzg.message.module.hades.struct;

import com.ayjs.mxzg.message.module.teamArena.domain.RoleSimpleMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2021/1/6
 **/
@Getter
@Setter
public class HadesRoleData {

    private long rid;

    /***
     * 玩家信息
     */
    private RoleSimpleMessage roleSimpleMessage;

    private int rank;

    private int floor;

    private int rankTime;

}
