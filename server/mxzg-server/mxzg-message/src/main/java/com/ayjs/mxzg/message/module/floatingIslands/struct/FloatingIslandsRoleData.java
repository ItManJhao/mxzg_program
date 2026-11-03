package com.ayjs.mxzg.message.module.floatingIslands.struct;

import com.ayjs.mxzg.message.module.teamArena.domain.RoleSimpleMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Setter
@Getter
public class FloatingIslandsRoleData {

    private long rid;

    /***
     * 玩家信息
     */
    private RoleSimpleMessage roleSimpleMessage;

    /***
     * 积分，对应总伤害
     */
    private long totalDmg;

    /***
     * 单次最大伤害
     */
    private long maxDmg;


}
