package com.ayjs.mxzg.message.module.teamArena.domain;

import lombok.Getter;
import lombok.Setter;

/**
 * 成员数据
 * @Author: CWJ
 * @Date: 2020/4/13
 **/
@Getter
@Setter
public class ArenaTeamMember {

    private long rid;

    /***
     * 是否隐藏
     */
    private boolean hidden;

    /***
     * 组队竞技场的阵容战斗力
     */
    private int fighting;

}
